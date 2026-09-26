#!/bin/bash

# Alias common navigation commands
alias c='clear'
alias ld='du -h -d 1'

# Proper color handling for coreutils ls
if [[ "$OSTYPE" == "linux"* ]]; then
    # Enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" \
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

# Add a g<alias> shell alias for each git alias in .gitconfig. Cache them,
# and make them again only when .gitconfig or this file changes
alias g='git'

BASH_ALIASES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/bash/.bash_aliases_cache"
if [[ ! -s $BASH_ALIASES_CACHE || ~/.gitconfig -nt $BASH_ALIASES_CACHE \
    || ${BASH_SOURCE[0]} -nt $BASH_ALIASES_CACHE ]]; then
    mkdir -p "${BASH_ALIASES_CACHE%/*}"
    git config --get-regexp '^alias\.' | while read -r al _; do
        al=${al#alias.}
        echo "alias g$al='git $al'; complete -F __git_alias_complete g$al"
    done > "$BASH_ALIASES_CACHE"
fi
# shellcheck source=/dev/null
. "$BASH_ALIASES_CACHE"

# On the first tab press after a g<alias>, load git's completion and give the
# alias the completion of the git command it runs. Return 124 so that bash
# completes again with the new completion
__git_alias_complete() {
    local cmd
    declare -F __git_complete >/dev/null \
        || _comp_load git 2>/dev/null || __load_completion git 2>/dev/null
    cmd=$(__git_aliased_command "${1#g}" 2>/dev/null)
    if declare -F "_git_$cmd" >/dev/null; then
        __git_complete "$1" "_git_$cmd"
    else
        complete -o default "$1"
    fi
    return 124
}

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
alias ......='cd ../../../../..'

# Don't delete entire filesystems
alias rm='rm -I'

# Vim/neovim aliases if each installed
if type nvim > /dev/null 2> /dev/null; then
    # Open last file
    v() {
        if [ "$1" = "-" ]; then
            nvim -c ":e#<1"
        else
            nvim "$@"
        fi
    }
    alias v-='nvim -c ":e#<1"'
    # Open straight into diff view
    alias vv='nvim -c "DiffviewOpen"'
    alias vr='nvim -c "normal ,vr"'
    # Open an fzf-picked file in (neo)vim; on escape, close the picker
    # without opening a blank buffer. Previews file contents like ctrl-t
    vf() {
        local file
        file=$(fzf --preview "$FZF_FILE_PREVIEW") && [ -n "$file" ] && nvim "$file"
    }
    alias fv='vf'
elif type vim > /dev/null 2> /dev/null; then
    alias v='vim'
fi

# Fix missing SSH keys on Mac and for SSH forwarding in tmux
alias fixssh='\
    [[ "$OSTYPE" == "darwin"* ]] && ssh-add --apple-use-keychain -q; \
    tmux ls &> /dev/null && eval "$(tmux showenv -s SSH_AUTH_SOCK)"\
    '
