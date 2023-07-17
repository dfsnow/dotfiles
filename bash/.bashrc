#!/bin/bash

# Set localization options
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Multi-line command uses single history entry
shopt -s cmdhist

# For setting history length see HISTSIZE and HISTFILESIZE in bash
HISTSIZE=10000
HISTFILESIZE=20000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize


###############################################################
# => TERM setup 
###############################################################

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")

# If Linux, try to determine if Debian-based 
if [ "$UNAME" == "linux" ] && [ -f /etc/debian_version ]; then
    export DISTRO="debian"
fi

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Check if colours are supported
__colour_enabled() {
    local -i colors=$(tput colors 2>/dev/null)
    [[ $? -eq 0 ]] && [[ $colors -gt 2 ]]
}
unset __colourise_prompt && __colour_enabled && __colourise_prompt=1

# Create custom bash prompt: https://stackoverflow.com/a/38758377
__set_bash_prompt()
{
    local PreGitPS1="${debian_chroot:+($debian_chroot)}"
    local PostGitPS1=""

    if [[ $__colourise_prompt ]]; then
        export GIT_PS1_SHOWCOLORHINTS=1
        local BGre='\[\e[1;32m\]'
        local BBlu='\[\e[1;34m\]'
        local None='\[\e[0m\]'
        if [[ -n "$VIRTUAL_ENV" ]]; then
            PreGitPS1+="($(basename $VIRTUAL_ENV)) "
        fi
        PreGitPS1+="$BGre\u@\h$None:$BBlu\w$None"
    else
        unset GIT_PS1_SHOWCOLORHINTS
        PreGitPS1="${debian_chroot:+($debian_chroot)}\u@\h:\w"
    fi

    PostGitPS1+="$None"'\$ '"$None"
    __git_ps1 "$PreGitPS1" "$PostGitPS1" ' (%s)'
}

PROMPT_COMMAND=__set_bash_prompt
PROMPT_DIRTRIM=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1

# Fallback if git-prompt.sh is not available
if [ "$(type -t __git_ps1)" != function ]; then
    function __git_ps1 {
        :
    }
fi


###############################################################
# => Source additional scripts
###############################################################

# Enable programmable completion features (linux)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi

# Enable homebrew and programmable completion features (Mac)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if [ -f "$(brew --prefix)"/etc/profile.d/bash_completion.sh ]; then
        . "$(brew --prefix)"/etc/profile.d/bash_completion.sh
    fi
fi

# Add third-party bash feature support
[ -f ~/dotfiles/vendor/fzf.bash ] \
    && source ~/dotfiles/vendor/fzf.bash
[ -f ~/dotfiles/vendor/git-completion.bash ] \
    && source ~/dotfiles/vendor/git-completion.bash
[ -f ~/dotfiles/vendor/git-prompt.sh ] \
    && source ~/dotfiles/vendor/git-prompt.sh __git_complete g __git_main
[ -f ~/.cargo/env ] && source ~/.cargo/env

# Add alias definitions
[ -f ~/dotfiles/bash/.bash_aliases ] \
    && source ~/dotfiles/bash/.bash_aliases


###############################################################
# => Exports env vars
###############################################################

# GPG pinentry setup
GPG_TTY=$(tty)
export GPG_TTY

# Set editor to best available
if type nvim >/dev/null 2>/dev/null; then
    export VISUAL=nvim
elif type vim >/dev/null 2>/dev/null; then
    export VISUAL=vim
else
    export VISUAL=vi
fi
export EDITOR="$VISUAL"

# For Debian systems add alias for fd, since fd is fdfind in apt
if echo "$DISTRO" | grep -q "debian"; then alias fd=fdfind; fi
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --layout=reverse"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow 2> /dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --follow --hidden \
    --exclude '**/.npm' --exclude '**/.rustup' --exclude '**/Library' \
    --exclude '**/.tldrc' --exclude '**/.tldr' --exclude '**/.cargo' \
    --exclude '**/.local' --exclude '**/.git' --exclude '**/.cache' \
    --exclude '**/.vim' . $HOME"

# Remove bash deprecation warning message on Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Unset setup variables
unset UNAME DISTRO
