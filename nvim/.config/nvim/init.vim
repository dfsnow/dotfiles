" Load settings from ..vimrc
set runtimepath^=/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
