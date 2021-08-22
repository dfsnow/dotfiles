#!/bin/bash

# Set localization options
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Enable programmable completion features (linux)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
	    . /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
	fi
    fi

# Enable programmable completion features (mac)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]; then
	. $(brew --prefix)/etc/profile.d/bash_completion.sh
    fi
fi

# Add git bash completion
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# Add alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Set editor to vim and edit mode to vim
export VISUAL=nvim
export EDITOR="$VISUAL"

# Fix nvim colors inside tmux
if [ -n "$TMUX" ]; then
    alias nvim="TERM=screen-256color nvim"
fi

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")

# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then

    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)

    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi

# Add fzf support
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# For Debian systems add alias for fd, since fd is fdfind in apt
if echo "$DISTRO" | grep -q "debian"; then alias fd=fdfind; fi
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --follow --hidden . $HOME"

# Unset setup variables
unset UNAME
unset DISTRO

# Enable proper GPG integration
export GPG_TTY=$(tty)
