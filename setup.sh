#!/bin/bash

set -euo pipefail

# Common packages across platforms
COMMON_PACKAGES=(
    "stow"
    "git"
    "ripgrep"
    "fzf"
    "htop"
    "zstd"
    "zoxide"
    "bat"
    "git-delta"
)

# Linux-specific packages
LINUX_PACKAGES=(
    "curl"
    "rename"
    "libssl-dev"
    "fd-find"
    "bash-completion"
)

# macOS-specific packages
MACOS_PACKAGES=(
    "neovim"
    "tmux"
    "fd"
    "bash"
    "bash-completion@2"
    "lazygit"
    "uv"
    "ruff"
    "air"
    "tree-sitter"
    "tree-sitter-cli"
    "gnupg"
    "pinentry-mac"
    "prek"
    "tree"
)

# Linux build dependencies
BUILD_DEPS=(
    "libevent-dev"
    "libncurses-dev"
    "byacc"
    "ninja-build"
    "gettext"
    "libtool"
    "libtool-bin"
    "autoconf"
    "automake"
    "cmake"
    "g++"
    "pkg-config"
    "unzip"
)

# Run from the repository, so that stow and the source builds work from any dir
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a Debian package is installed. `dpkg -l` also succeeds for
# packages that were removed but still have configuration files
deb_installed() {
    [[ "$(dpkg-query -W -f='${db:Status-Status}' "$1" 2>/dev/null)" == "installed" ]]
}

# Install script for linux-based systems
if [[ "$OSTYPE" == "linux"* ]]; then

    # Offer a source build of tmux if it is missing or is already a source
    # build (source builds report their version as "tmux next-X.Y")
    if ! command_exists tmux || [[ "$(tmux -V)" == *"tmux next"* ]]; then
        read -p "Install tmux from source? [yn] " -n 1 -r source_answer_tmux
        echo
    else
        echo "tmux already installed, skipping source build prompt"
        source_answer_tmux="n"
    fi

    if ! command_exists nvim; then
        read -p "Install neovim? [yn] " -n 1 -r source_answer_neovim
        echo
    else
        echo "neovim already installed, skipping source build prompt"
        source_answer_neovim="n"
    fi

    # Update package list only if not updated recently
    if [[ ! -f /var/lib/apt/periodic/update-success-stamp ]] || [[ $(find /var/lib/apt/periodic/update-success-stamp -mtime +1) ]]; then
        echo "Updating package list..."
        sudo apt update
    fi

    # Install basic utilities
    all_linux_packages=("${COMMON_PACKAGES[@]}" "${LINUX_PACKAGES[@]}")

    # Check which packages need to be installed
    packages_to_install=()
    for pkg in "${all_linux_packages[@]}"; do
        if ! deb_installed "$pkg"; then
            packages_to_install+=("$pkg")
        fi
    done

    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        echo "Installing missing packages: ${packages_to_install[*]}"
        sudo apt install -y "${packages_to_install[@]}"
    else
        echo "All basic packages already installed"
    fi

    # Install build dependencies if building from source
    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]] || [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
        build_deps_to_install=()
        for pkg in "${BUILD_DEPS[@]}"; do
            if ! deb_installed "$pkg"; then
                build_deps_to_install+=("$pkg")
            fi
        done

        if [[ ${#build_deps_to_install[@]} -gt 0 ]]; then
            echo "Installing build dependencies: ${build_deps_to_install[*]}"
            sudo apt install -y "${build_deps_to_install[@]}"
        else
            echo "All build dependencies already installed"
        fi
    fi

    # Install the latest version of tmux from source
    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]]; then
        if [[ -d "build_tmux" ]]; then
            echo "Removing existing tmux build directory..."
            rm -rf build_tmux
        fi

        echo "Building tmux from source..."
        git clone https://github.com/tmux/tmux.git build_tmux
        cd build_tmux || exit
        sh autogen.sh
        ./configure
        make
        sudo make install
        cd ..
        rm -rf build_tmux
    elif ! command_exists tmux; then
        echo "Installing tmux from apt..."
        sudo apt install -y tmux
    fi

    # Install the latest version of neovim from source
    if [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
        if [[ -d "build_neovim" ]]; then
            echo "Removing existing neovim build directory..."
            rm -rf build_neovim
        fi

        echo "Building neovim from source..."
        git clone https://github.com/neovim/neovim.git build_neovim
        cd build_neovim || exit
        git checkout tags/stable
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
        cd ..
        rm -rf build_neovim
    fi

# Install script for mac-based systems
elif [[ "$OSTYPE" == "darwin"* ]]; then

    # Check if Homebrew is installed
    if ! command_exists brew; then
        echo "Homebrew not found. Please install Homebrew first."
        exit 1
    fi

    all_macos_packages=("${COMMON_PACKAGES[@]}" "${MACOS_PACKAGES[@]}")
    packages_to_install=()
    packages_to_upgrade=()

    installed=$'\n'"$(brew list --formula)"$'\n'
    for pkg in "${all_macos_packages[@]}"; do
        if [[ "$installed" == *$'\n'"$pkg"$'\n'* ]]; then
            packages_to_upgrade+=("$pkg")
        else
            packages_to_install+=("$pkg")
        fi
    done

    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        echo "Installing: ${packages_to_install[*]}"
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "${packages_to_install[@]}"
    fi

    if [[ ${#packages_to_upgrade[@]} -gt 0 ]]; then
        echo "Upgrading: ${packages_to_upgrade[*]}"
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "${packages_to_upgrade[@]}"
    fi

    # Hush login message
    if [[ ! -f ~/.hushlogin ]]; then
        echo "Creating ~/.hushlogin..."
        touch ~/.hushlogin
    else
        echo "~/.hushlogin already exists"
    fi
fi

# Symlink the config files into the home directory with GNU stow
stow_packages=(tmux bash git vim nvim lazygit bat rstudio htop ghostty claude gpg)
stow --dir="$DOTFILES_DIR" --target="$HOME" "${stow_packages[@]}"
echo "Config files stowed"
echo "Setup completed successfully!"
