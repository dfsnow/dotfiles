# Alias common navigation commands
alias c='clear'
alias ld='du -h -d 1'

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

# Proper color handling for coreutils ls
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias l='ls -hGF --color=auto'
    alias ls='ls -hGF --color=auto'
    alias ll='ls -lahGF --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias l='ls -hGF'
    alias ls='ls -hGF'
    alias ll='ls -lahGF'
    o() {
      open --reveal "${1:-.}"
    }
fi

# Git related aliases automatically added by .gitconfig
alias g='git'

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do

    alias g${al}="git ${al}"

    complete_func=_git_$(__git_aliased_command ${al})
    function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
done
unset al

# Aliases for directory backtracking
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Vim/neovim aliases if each installed
if type vim >/dev/null 2>/dev/null; then
    alias v='vim'
    alias vi='vim'
fi

if type nvim >/dev/null 2>/dev/null; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias nv='nvim'

    # Open wiki.vim and journal
    alias nv='vim +WikiFzfPages'
    alias nj='vim +WikiJournal'
fi

