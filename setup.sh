#!/bin/bash

set -euo pipefail

# Common packages across platforms
COMMON_PACKAGES=(
    "stow"
    "git"
    "ripgrep"
    "zstd"
    "mosh"
    "zoxide"
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
    "fzf"
    "fd"
    "bash"
    "bash-completion@2"
    "lazygit"
    "uv"
    "ruff"
    "air"
)

# Linux build dependencies
BUILD_DEPS=(
    "libevent-dev"
    "libncurses5-dev"
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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if directory exists and is not empty
dir_exists_and_not_empty() {
    [[ -d "$1" && -n "$(ls -A "$1" 2>/dev/null)" ]]
}

# Install script for linux-based systems
if [[ "$OSTYPE" == "linux-gnu" ]]; then

    # Only prompt if tmux/neovim aren't already installed from source
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
        if ! dpkg -l "$pkg" >/dev/null 2>&1; then
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
            if ! dpkg -l "$pkg" >/dev/null 2>&1; then
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
        ./configure && make && sudo make install
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

    # Install brew package if not exists, else upgrade
    __install_or_upgrade() {
        if brew ls --versions "$1" >/dev/null; then
            echo "Upgrading $1..."
            HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
        else
            echo "Installing $1..."
            HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
        fi
    }

    all_macos_packages=("${COMMON_PACKAGES[@]}" "${MACOS_PACKAGES[@]}")
    for pkg in "${all_macos_packages[@]}"; do
        __install_or_upgrade "$pkg"
    done

    # Install fzf key bindings if not already done
    if [[ ! -f ~/.fzf.bash ]]; then
        echo "Installing fzf key bindings..."
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc
    else
        echo "fzf key bindings already installed"
    fi

    # Hush login message
    if [[ ! -f ~/.hushlogin ]]; then
        echo "Creating ~/.hushlogin..."
        touch ~/.hushlogin
    else
        echo "~/.hushlogin already exists"
    fi
fi

# Create symlinks to all files and folders using GNU stow
stow_packages=(tmux bash git vim nvim lazygit)
for pkg in "${stow_packages[@]}"; do
    if [[ -d "$pkg" ]]; then
        if ! dir_exists_and_not_empty "$HOME/.${pkg}" && [[ "$pkg" != "bash" ]] && [[ "$pkg" != "git" ]]; then
            echo "Stowing $pkg..."
            stow "$pkg"
        elif [[ "$pkg" == "bash" ]] && [[ ! -L "$HOME/.bashrc" ]]; then
            echo "Stowing $pkg..."
            stow "$pkg"
        elif [[ "$pkg" == "git" ]] && [[ ! -L "$HOME/.gitconfig" ]]; then
            echo "Stowing $pkg..."
            stow "$pkg"
        else
            echo "$pkg config already stowed or exists"
        fi
    else
        echo "Warning: $pkg directory not found, skipping stow"
    fi
done
echo "Config files stowed"

# Reset inputrc and bashrc only if they exist
if [[ -f ~/.inputrc ]]; then
    echo "Reloading inputrc..."
    bind -f ~/.inputrc
fi

if [[ -f ~/.bashrc ]]; then
    echo "Sourcing bashrc..."
    source "$HOME/.bashrc"
fi

echo "Setup completed successfully!"
