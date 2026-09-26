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


###############################################################
# => Source additional scripts
###############################################################

# Save the output of a command to a file, so that new shells can source the
# file instead of running the command. Remake the file when the command or
# its directory is newer. Homebrew keeps the build date on binaries but
# updates bin/ when it relinks an upgrade
__cache() {
    local file=$1 bin
    shift
    hash "$1" 2>/dev/null || return 1
    bin=${BASH_CMDS[$1]}
    if [[ ! -s $file || $bin -nt $file || ${bin%/*} -nt $file ]]; then
        mkdir -p "${file%/*}"
        "$@" > "$file" 2>/dev/null || { rm -f "$file"; return 1; }
    fi
}
__cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/bash"
__comp_dir="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion"

# Find Homebrew on Apple silicon, Intel Macs, and Linux
for __dir in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    [[ -x $__dir/bin/brew ]] && HOMEBREW_PREFIX=$__dir && break
done
unset __dir

if [[ -n ${HOMEBREW_PREFIX-} ]]; then
    # Use Homebrew's unversioned python. Add it only once, for nested shells
    [[ :$PATH: == *:$HOMEBREW_PREFIX/opt/python/libexec/bin:* ]] \
        || export PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"

    # bash-completion sources every script in etc/bash_completion.d at
    # startup, which takes about 0.5 seconds with Homebrew. Turn that off
    # and link the directory as a user directory instead, so that each
    # script loads on the first tab press for its command
    [[ -e $__cache_dir/brew/completions ]] || { mkdir -p "$__cache_dir/brew" \
        && ln -s "$HOMEBREW_PREFIX/etc/bash_completion.d" "$__cache_dir/brew/completions"; }
    BASH_COMPLETION_COMPAT_DIR=/dev/null
    BASH_COMPLETION_USER_DIR="$__comp_dir:$__cache_dir/brew"
fi

# Enable programmable completion
if ! shopt -oq posix; then
    for __file in "${HOMEBREW_PREFIX-}/etc/profile.d/bash_completion.sh" \
        /usr/share/bash-completion/bash_completion /etc/bash_completion; do
        [[ -r $__file ]] && . "$__file" && break
    done
    unset __file
fi

# Load the git prompt from Homebrew, since it is no longer sourced at
# startup. Use a prompt without git information if it is missing
[[ -r ${HOMEBREW_PREFIX-}/etc/bash_completion.d/git-prompt.sh ]] \
    && . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"
declare -F __git_ps1 >/dev/null || __git_ps1() { PS1="$1$2"; }

# Add Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Add zoxide and fzf integration
__cache "$__cache_dir/zoxide.bash" zoxide init bash && . "$__cache_dir/zoxide.bash"
__cache "$__cache_dir/fzf.bash" fzf --bash && . "$__cache_dir/fzf.bash"

# Save completion scripts that tools print into the bash-completion user
# directory, so that they load on the first tab press
__cache "$__comp_dir/completions/uv" uv generate-shell-completion bash
__cache "$__comp_dir/completions/ruff" ruff generate-shell-completion bash
__cache "$__comp_dir/completions/rg" rg --generate complete-bash
unset __comp_dir

# Other envs and aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases


###############################################################
# => Exports env vars
###############################################################

# Directories to ignore in fzf/rg/fd searches, shared across neovim and bash
FZF_IGNORE=(
    .git .npm .rustup .tldrc .tldr .cargo
    .Rproj.user .mypy_cache .local .cache
    node_modules renv venv .venv __pycache__
    .terraform .docker .kube
    target dist build _build
)
FZF_RG_IGNORES=""
FZF_FD_IGNORES=""
for __dir in "${FZF_IGNORE[@]}"; do
    FZF_RG_IGNORES+=" -g '!${__dir}/'"
    FZF_FD_IGNORES+=" -E ${__dir}"
done
unset __dir
export FZF_RG_IGNORES
export FZF_FD_IGNORES

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
    --layout=reverse --exit-0 \
    --bind 'J:down,K:up'"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow \
    ${FZF_RG_IGNORES} 2> /dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='__fzf_alt_c_command'

# Shared preview commands for fzf widgets, using the best tool available
if type bat >/dev/null 2>/dev/null; then
    FZF_FILE_PREVIEW='bat --color=always --style=numbers --line-range :500 {}'
else
    FZF_FILE_PREVIEW='head -n 500 {}'
fi
if type tree >/dev/null 2>/dev/null; then
    FZF_DIR_PREVIEW='tree -C -L 2 {} | head -n 200'
else
    FZF_DIR_PREVIEW='ls -lAhp {} | head -n 200'
fi

# Preview file contents for the file widget (ctrl-t and esc+space) and the
# directory contents for the dir widget (alt-c)
export FZF_CTRL_T_OPTS="--preview '$FZF_FILE_PREVIEW'"
export FZF_ALT_C_OPTS="--preview '$FZF_DIR_PREVIEW'"

# Remove bash deprecation warning message on Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1


###############################################################
# => FZF functions and keybinds
###############################################################

# Use esc+space to pick files
bind -m vi-insert -x '"\e ": fzf-file-widget'
bind -m vi-move  -x '"\e ": fzf-file-widget'

# Use zoxide for alt-C, but append local dirs when in a git directory
__fzf_alt_c_command() {
    local search_dir="$HOME"
    local git_dirs=""
    if git rev-parse --git-dir &>/dev/null; then
        search_dir="$(git rev-parse --show-toplevel)"
        git_dirs=$(echo "$search_dir"; "$FZF_FIND" --type d --follow --hidden \
            ${FZF_FD_IGNORES} . "$search_dir")
    fi

    echo "$(zoxide query --list)"$'\n'"$git_dirs"
}
export -f __fzf_alt_c_command

# Use fzf to pick git-changed files and open them in (neo)vim
vg() {
    local files
    files=$(git status --porcelain --untracked-files=all 2>/dev/null \
        | fzf --multi --prompt 'git> ' \
            --preview 'f=$(sed -e "s/^...//" -e "s/.* -> //" <<< {}); \
                git diff --color=always -- "$f" 2>/dev/null | head -500' \
        | sed -e 's/^...//' -e 's/.* -> //')
    [ -n "$files" ] && ${VISUAL:-nvim} $files
}

# Use esc+g to pick git-changed files
bind -m vi-insert -x '"\eg": vg'
bind -m vi-move  -x '"\eg": vg'

# Use esc+f to pick a file and open it in (neo)vim
bind -m vi-insert -x '"\ef": vf'
bind -m vi-move  -x '"\ef": vf'

# Use esc+b to pick a git branch and check it out
bind -m vi-insert -x '"\eb": gbf'
bind -m vi-move  -x '"\eb": gbf'

# Search SSH config file
fs () {
  server=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' \
    | fzf --preview \
      'ssh -G {} 2>/dev/null | grep -iE "^(hostname|user|port|identityfile|proxyjump) "')
  if [[ -n $server ]]; then
    ssh "$server"
  fi
}
alias fssh='fs'
