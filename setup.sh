#!/bin/bash

# Install script for linux-based systems
if [[ "$OSTYPE" == "linux-gnu" ]]; then

    # Prompt to install tmux from source, otherwise install from apt
    read -p "Install tmux from source? [yn] " -n 1 -r source_answer_tmux
    echo

    # Prompt to install neovim, otherwise only use vim
    read -p "Install neovim? [yn] " -n 1 -r source_answer_neovim
    echo

    # Install basic utilities
    sudo apt install -y \
        curl stow rename git libssl-dev fd-find \
        ripgrep zstd bash-completion mosh

    # Install build dependencies if building from source
    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]] || [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
        sudo apt install -y \
            libevent-dev libncurses5-dev byacc \
            ninja-build gettext libtool libtool-bin \
            autoconf automake cmake g++ pkg-config unzip
    fi

    # Install the latest version of tmux
    if [[ "$source_answer_tmux" =~ ^[Yy]$ ]]; then
        git clone https://github.com/tmux/tmux.git build_tmux
        cd build_tmux || exit
        sh autogen.sh
        ./configure && make && sudo make install
        cd ..
        rm -rf build_tmux
    else
        sudo apt install -y tmux
    fi

    # Install the latest version of neovim
    if [[ "$source_answer_neovim" =~ ^[Yy]$ ]]; then
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

    # Install brew package if not exists, else upgrade
    __install_or_upgrade() {
        if brew ls --versions "$1" > /dev/null; then
            HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
        else
            HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
        fi
    }

    for pkg in stow neovim tmux git fzf fd ripgrep zstd bash bash-completion@2 mosh lazygit uv ruff; do
        __install_or_upgrade "$pkg"
    done

    # Install fzf
    "$(brew --prefix)"/opt/fzf/install

    # Hush login message
    touch ~/.hushlogin
fi

# Create symlinks to all files and folders using GNU stow
for pkg in tmux bash git vim nvim lazygit; do
    stow "$pkg"
done
echo "Config files stowed"

# Reset inputrc and bashrc
bind -f ~/.inputrc
source "$HOME/.bashrc"
echo "Bash configs installed"
