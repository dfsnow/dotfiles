#!/bin/bash

# Alias common navigation commands
alias c='clear'
alias ld='du -h -d 1'

# Proper color handling for coreutils ls
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        (test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)") \
            || eval "$(dircolors -b)"
    fi
    alias ls='ls -hF --color=auto'
    alias ll='ls -lahF --time-style "+%Y-%m-%d %H:%M:%S" --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLOR=1
    alias ls='ls -hGF'
    alias ll='ls -lahGF -D "%Y-%m-%d %H:%M:%S"'
fi

# Fix bad dir colors on specific machines
LS_COLORS=$LS_COLORS:'ow=1;34:'
export LS_COLORS

# Git related aliases automatically added by .gitconfig. Cache the resulting
# config file so we don't have to rebuild the aliases for every new shell 
alias g='git'

function_exists() {
    declare -f -F "$1" > /dev/null
    return $?
}

BASH_ALIASES_CACHE="$HOME/.cache/bash/.bash_aliases_cache"
[ ! -d "$(dirname "$BASH_ALIASES_CACHE")" ] && mkdir -p "$(dirname "$BASH_ALIASES_CACHE")"
if [ -f "$BASH_ALIASES_CACHE" ] && [ "$(find "$BASH_ALIASES_CACHE" -mtime 0)" != "" ]; then
    # shellcheck source=/dev/null
    . "$BASH_ALIASES_CACHE"
else
    # The cache file doesn't exist or is old, so regenerate it. Remove any
    # existing file first so we don't append to it forever
    rm -rf "$BASH_ALIASES_CACHE"
    touch "$BASH_ALIASES_CACHE"
    for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
        echo "alias g${al}='git ${al}'" >> "$BASH_ALIASES_CACHE"
        complete_func=_git_"$(__git_aliased_command "${al}")"
        function_exists "${complete_func}" && \
            echo "__git_complete g${al} ${complete_func}" \
            >> "$BASH_ALIASES_CACHE"
    done
    # shellcheck source=/dev/null
    . "$BASH_ALIASES_CACHE"
fi

# Lazygit aliases if installed
if type lazygit > /dev/null 2> /dev/null; then
    alias lg='lazygit'
    alias gg='lazygit'
fi

# Aliases for directory backtracking
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Don't delete entire filesystems
alias rm='rm -I'

# Vim/neovim aliases if each installed
if type nvim > /dev/null 2> /dev/null; then
    alias v='nvim'
    # Open last file
    alias vv='nvim -c":e#<1"'
    # Open file in neovim with fzf
    alias vf='nvim $(fzf)'
    alias vvv='nvim $(fzf)'
elif type vim > /dev/null 2> /dev/null; then
    alias v='vim'
fi

# Fix missing SSH keys on Mac and for SSH forwarding in tmux
alias fixssh='\
    [[ "$OSTYPE" == "darwin"* ]] && ssh-add --apple-use-keychain -q; \
    eval $(tmux showenv -s SSH_AUTH_SOCK)\
    '
