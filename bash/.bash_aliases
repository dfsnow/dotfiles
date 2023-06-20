#!/bin/bash

# Alias common navigation commands
alias c='clear'
alias ld='du -h -d 1'

# Proper color handling for coreutils ls
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors \
            && eval "$(dircolors -b ~/.dircolors)" \
            || eval "$(dircolors -b)"
    fi
    alias l='ls -hGF --color=auto'
    alias ls='ls -hGF --color=auto'
    alias ll='ls -lahGF --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLOR=1
    alias l='ls -hGF'
    alias ls='ls -hGF'
    alias ll='ls -lahGF'
    o() {
        open --reveal "${1:-.}"
    }
fi
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS

# Git related aliases automatically added by .gitconfig
alias g='git'

function_exists() {
    declare -f -F "$1" > /dev/null
    return $?
}

for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
    alias g"${al}"="git ${al}"
    complete_func=_git_"$(__git_aliased_command "${al}")"
    function_exists "${complete_func}" && __git_complete g"${al}" "${complete_func}"
done
unset al

# Aliases for directory backtracking
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Vim/neovim aliases if each installed
if type nvim > /dev/null 2> /dev/null; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias nv='nvim'
elif type vim > /dev/null 2> /dev/null; then
    alias v='vim'
    alias vi='vim'
fi

# Setup Z with fzf
source ~/dotfiles/z.sh
unalias z 2> /dev/null
z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')" || return
}
