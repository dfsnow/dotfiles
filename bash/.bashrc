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
        local BGre='\[\e[1;32m\]';
        local BBlu='\[\e[1;34m\]';
        local None='\[\e[0m\]' # Return to default colour
        PreGitPS1+="$BGre\u@\h$None:$BBlu\w$None"
    else
        unset GIT_PS1_SHOWCOLORHINTS
        PreGitPS1="${debian_chroot:+($debian_chroot)}\u@\h:\w"
    fi

    PostGitPS1+="$None"'\$ '"$None"
    __git_ps1 "$PreGitPS1" "$PostGitPS1" '(%s)'
}

PROMPT_COMMAND=__set_bash_prompt
PROMPT_DIRTRIM=1
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

# Add fzf support
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Add git bash completion
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh __git_complete g __git_main

# Add alias definitions
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Add cargo support
[ -f ~/.cargo/env ] && source ~/.cargo/env


###############################################################
# => Exports env vars
###############################################################

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
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow 2> /dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --follow --hidden --exclude '**/.npm' --exclude '**/.rustup' --exclude '**/Library' --exclude '**/.tldrc' --exclude '**/.tldr' --exclude '**/.cargo' --exclude '**/.local' --exclude '**/.git' --exclude '**/.cache' --exclude '**/.vim' . $HOME"

# Use Dracula theme for bat
export BAT_THEME="Dracula"

# Remove bash deprecation warning message on Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Unset setup variables
unset UNAME DISTRO
