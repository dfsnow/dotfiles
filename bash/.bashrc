#!/bin/bash

# Set localization options
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Append to the history file, don't overwrite it
shopt -s histappend

# Multi-line command uses single history entry
shopt -s cmdhist

# Set history file location
HISTFILE=~/.bash_history

# For setting history length see HISTSIZE and HISTFILESIZE in bash
HISTSIZE=200000
HISTFILESIZE=200000

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Ignore common commands in history
HISTIGNORE="ls:ll:cd:pwd:exit:clear:history"

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
    local colors; colors=$(tput colors 2>/dev/null)
    [[ $? -eq 0 && $colors -gt 2 ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]
}
unset __colourise_prompt && __colour_enabled && __colourise_prompt=1

# Create custom bash prompt: https://stackoverflow.com/a/38758377
__set_bash_prompt()
{
    local PreGitPS1="${debian_chroot:+($debian_chroot)}"
    local PostGitPS1=""

    if [[ -n "$VIRTUAL_ENV" ]]; then
        PreGitPS1+="($(basename "$VIRTUAL_ENV")) "
    fi

    local Title='\033]0;'
    local Bell='\007'
    local BGre='\[\e[1;32m\]'
    local BBlu='\[\e[1;34m\]'
    local None='\[\e[0m\]'
    case "$TERM" in 
        xterm*|screen*) 
            if [[ $__colourise_prompt ]]; then
                export GIT_PS1_SHOWCOLORHINTS=1
                PreGitPS1+="\[$Title\u@\h$Bell\]$BBlu\w$None"
            else
                unset GIT_PS1_SHOWCOLORHINTS
                PreGitPS1+="\[$Title\u@\h$Bell\]\w"
            fi
        ;;
         *)
         if [[ $__colourise_prompt ]]; then
            export GIT_PS1_SHOWCOLORHINTS=1
            PreGitPS1+="\[$Title\u@\h$Bell\]$BGre\u@\h$None:$BBlu\w$None"
        else
            PreGitPS1+="\u@\h:\w"
        fi
    esac
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
    brew_prefix=/opt/homebrew/
    export PATH="$brew_prefix/opt/python/libexec/bin:$PATH"
    [[ -r "$brew_prefix/etc/profile.d/bash_completion.sh" ]] \
        && . "$brew_prefix/etc/profile.d/bash_completion.sh"
fi

# Add third-party bash completion support
__add_completion() {
    local cmd=$1
    local completion_arg=$2
    if type "$cmd" >/dev/null 2>/dev/null && "$cmd" "$completion_arg" >/dev/null 2>/dev/null; then
        eval "$("$cmd" "$completion_arg")"
    fi
}
__add_completion uv "--generate-shell-completion bash"
__add_completion ruff "--generate-shell-completion bash"
__add_completion rg "--generate complete-bash"
if [ -f ~/.fzf.bash ]; then
    . ~/.fzf.bash
else
    __add_completion fzf "--bash"
fi

[ -f ~/dotfiles/vendor/git-completion.bash ] \
    && . ~/dotfiles/vendor/git-completion.bash
[ -f ~/dotfiles/vendor/git-prompt.sh ] \
    && . ~/dotfiles/vendor/git-prompt.sh __git_complete g __git_main
[ -f ~/.cargo/env ] \
    && . ~/.cargo/env

# Add alias definitions
[ -f ~/dotfiles/bash/.bash_aliases ] \
    && . ~/dotfiles/bash/.bash_aliases


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
if type fd >/dev/null 2>/dev/null; then
    export FZF_FIND=fd
elif type fdfind >/dev/null 2>/dev/null; then
    export FZF_FIND=fdfind
    alias fd=fdfind
fi

export FZF_DEFAULT_OPTS=" --height 40% \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --layout=reverse --exit-0"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow \
    -g '!{.npm,.rustup,.tldrc,.tldr,.cargo,.git}/' \
    -g '!{node_modules,renv}/' \
    2> /dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='__fzf_alt_c_command'

# Search from home when not in git dir, else from git root
__fzf_alt_c_command() {
    local search_dir="$HOME"
    if git rev-parse --git-dir &>/dev/null; then
        search_dir="$(git rev-parse --show-toplevel)"
        echo "$search_dir"; "$FZF_FIND" --type d --follow --hidden \
            --exclude '**/.git' --exclude '**/.local' \
            . "$search_dir"
    else
        echo "$search_dir"; "$FZF_FIND" --type d --follow --hidden \
            --exclude '**/.npm' --exclude '**/.rustup' --exclude '**/.tldrc' \
            --exclude '**/.tldr' --exclude '**/.cargo' --exclude '**/.git' \
            --exclude '**/.cache' --exclude '**/.local' --exclude '**/.vim' \
            --exclude '**/Library' . "$search_dir"
    fi
}
export -f __fzf_alt_c_command

# Remove bash deprecation warning message on Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Unset setup variables
unset UNAME DISTRO
