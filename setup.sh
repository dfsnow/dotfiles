#!/bin/bash

set -euo pipefail

COMMON_PACKAGES=(
    stow git ripgrep fzf htop zstd zoxide git-delta
)

LINUX_PACKAGES=(
    curl rename libssl-dev fd-find bash-completion
)

MACOS_PACKAGES=(
    neovim tmux fd bash bash-completion@2 lazygit uv ruff
    tree-sitter tree-sitter-cli gnupg pinentry-mac prek tree
)

BUILD_DEPS=(
    libevent-dev libncurses-dev byacc ninja-build gettext libtool
    libtool-bin autoconf automake cmake g++ pkg-config unzip
)

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install only missing packages. Removed packages can still have dpkg records
install_deb_packages() {
    local pkg
    local missing=()

    for pkg in "$@"; do
        if [[ "$(dpkg-query -W -f='${db:Status-Status}' "$pkg" 2>/dev/null)" != "installed" ]]; then
            missing+=("$pkg")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Installing missing packages: ${missing[*]}"
        sudo apt install -y "${missing[@]}"
    else
        echo "All requested packages already installed"
    fi
}

# Keep each build in a temporary directory and clean up on success or failure
build_from_source() (
    project="$1"
    build_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-$project.XXXXXX")"
    trap 'rm -rf "$build_dir"' EXIT

    echo "Building $project from source..."
    git clone "https://github.com/$project/$project.git" "$build_dir"
    cd "$build_dir"

    case "$project" in
        tmux)
            sh autogen.sh
            ./configure
            make
            ;;
        neovim)
            git checkout tags/stable
            make CMAKE_BUILD_TYPE=RelWithDebInfo
            ;;
    esac
    sudo make install
)

if [[ "$OSTYPE" == "linux"* ]]; then
    source_answer_tmux="n"
    source_answer_neovim="n"

    # Offer a source build of tmux if it is missing or is already a source
    # build (source builds report their version as "tmux next-X.Y")
    if ! command_exists tmux || [[ "$(tmux -V)" == *"tmux next"* ]]; then
        read -p "Install tmux from source? [yn] " -n 1 -r source_answer_tmux
        echo
    else
        echo "tmux already installed, skipping source build prompt"
    fi

    if ! command_exists nvim; then
        read -p "Install neovim? [yn] " -n 1 -r source_answer_neovim
        echo
    else
        echo "neovim already installed, skipping source build prompt"
    fi

    # Update package list only if not updated recently
    if [[ ! -f /var/lib/apt/periodic/update-success-stamp ]] || [[ $(find /var/lib/apt/periodic/update-success-stamp -mtime +1) ]]; then
        echo "Updating package list..."
        sudo apt update
    fi

    install_deb_packages "${COMMON_PACKAGES[@]}" "${LINUX_PACKAGES[@]}"

    # Install build dependencies if building from source
    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]] || [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
        install_deb_packages "${BUILD_DEPS[@]}"
    fi

    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]]; then
        build_from_source tmux
    elif ! command_exists tmux; then
        echo "Installing tmux from apt..."
        sudo apt install -y tmux
    fi

    if [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
        build_from_source neovim
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command_exists brew; then
        echo "Homebrew not found. Please install Homebrew first."
        exit 1
    fi

    packages_to_install=()
    packages_to_upgrade=()

    installed=$'\n'"$(brew list --formula)"$'\n'
    for pkg in "${COMMON_PACKAGES[@]}" "${MACOS_PACKAGES[@]}"; do
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
stow_packages=(tmux bash git vim nvim lazygit bat htop ghostty claude gpg)
stow --dir="$DOTFILES_DIR" --target="$HOME" "${stow_packages[@]}"
echo "Config files stowed"
echo "Setup completed successfully!"
