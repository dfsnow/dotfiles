#!/bin/bash

# Set localization options
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

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

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


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
    eval $(/opt/homebrew/bin/brew shellenv)
    if [ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]; then
	. $(brew --prefix)/etc/profile.d/bash_completion.sh
    fi
fi

# Add fzf support
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Add git bash completion
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

# Add alias definitions
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Add cargo support
[ -f ~/.cargo/env ] && source ~/.cargo/env


###############################################################
# => Exports env vars
###############################################################

# Shorten dir depth displayed in prompt
PROMPT_DIRTRIM=1

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

# Setup Z with fzf
source $HOME/dotfiles/z.sh
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# Use Dracula theme for bat
export BAT_THEME="Dracula"

# Remove bash deprecation warning message on Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Unset setup variables
unset color_prompt force_color_prompt UNAME DISTRO
