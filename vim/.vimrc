call plug#begin('~/.vim/vim-plug')

" UI and colors
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'liuchengxu/vim-which-key'
Plug 'dracula/vim',{'as':'dracula'}

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Formatting
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'

" Movement and search
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Table of Contents
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> General
"    -> VIM User Interface
"    -> Colors and Fonts
"    -> Files and Backups
"    -> Text, Tab and Indent Related
"    -> Moving Around, Tabs and Buffers
"    -> Editing Mappings
"    -> Spell Checkings
"    -> Helper Functions
"    -> Miscellaneous


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast quitting and saving
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null
command Q :q!


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show the line number
set number

" Show a highlight on the cursorline
set cursorline

" Show the 80 char column
set colorcolumn=80


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set the default font
set guifont=DejaVu_Sans_Mono:h14

" Set background color
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, Backups and Undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git, etc anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, Tab and Indent Related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable smart auto indent and line wrapping
set ai
set si
set wrap

" Keep text selected on indent
vnoremap < <gv
vnoremap > >gv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, Tabs, Windows and Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Split new buffers to the right
set splitright
set splitbelow

" Window movement with leader
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>

" Open new buffers
map <leader>bb :new<cr>
map <leader>bv :vnew<cr>
map <leader>bn :enew<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>
map <leader>bc :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Switch between buffers in windows
map <leader>ll :bnext<cr>
map <leader>bl :bnext<cr>
map <leader>bh :bprevious<cr>
map <leader>hh :bprevious<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell Checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Spellfile language and location
set spelllang=en
set spellfile=$HOME/dotfiles/spell/en.utf-8.add


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable folding
set foldcolumn=1
set foldmethod=indent
set foldlevel=99

" Open README file with helpful tips
map <leader>r :e ~/dotfiles/README.md<CR>

" Toggle paste mode on and off
map <leader>v :setlocal paste!<cr>

" Better line joins
set formatoptions+=j

" Fix R indentation 
let r_indent_align_args = 0

" Remap enter and backspace in Normal mode
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {
nnoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
onoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
vnoremap <CR> }

" Replace word with last yank
nnoremap S diw"0P
vnoremap S "_d"0P"

" Decrease update time
set updatetime=100


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commentary
nnoremap <leader>c :Commentary<cr>
vnoremap <leader>c :Commentary<cr>

" Sneak
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map <space> <Plug>Sneak_s

" Signify
nmap <leader>gg :SignifyToggle<CR>
nmap <leader>gu :SignifyHunkUndo<CR>
nmap <leader>gd :SignifyHunkDiff<CR>
nmap <leader>gn <plug>(signify-next-hunk)
nmap <leader>gp <plug>(signify-prev-hunk)

" Git Fugitive
nmap <leader>gs :Git<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gc :Git commit<CR>

" Dracula
let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme'         : 'dracula',
    \ 'component_function'  : {'gitbranch': 'fugitive#head'}                  ,
    \ }

let g:lightline.tabline = {
    \ 'left'                : [['buffers']]                                   ,
    \ 'right'               : [['close']]                                     ,
    \ }

let g:lightline.component_expand = {
    \ 'buffers'             : 'lightline#bufferline#buffers'                  ,
    \ }

let g:lightline.component_type = {
    \ 'buffers'             : 'tabsel'                                        ,
    \ }

let g:lightline.active = {
    \ 'right' : [
    \   ['percent', 'line']                                                   ,
    \   ['fileformat', 'fileencoding', 'filetype'] ]                          ,
    \ 'left'  : [
    \   ['mode', 'paste']                                                     ,
    \   ['gitbranch']                                                         ,
    \   ['readonly', 'filename', 'modified'] ]                                ,
    \ }

" FZF
nnoremap ? :Files<CR>
nmap <leader>ff :Files<CR>
nmap <leader>fg :GFiles<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fh :History<CR>
nmap <leader>fl :BLines<CR>
nmap <leader>fm :Maps<CR>
nmap <leader>fc :Commits<CR>
nmap <leader>fr :Rg<CR>
nmap <leader>? :Rg<CR>

" WhichKey
nnoremap <silent> <leader><leader> :<c-u>WhichKey  ','<CR>
call which_key#register(',', "g:which_key_map")

" WhichKey defaults
let g:which_key_map = {
    \ 'c' : ['Commentary'                      , 'Toggle comment']            ,
    \ 'v' : [':setlocal paste!'                , 'Paste mode']                ,
    \ 'r' : [':e ~/dotfiles/README.md'         , 'Open README']               ,
    \ '?' : ['Files'                           , 'Search all files']          ,
    \ 'h' : ['<C-W><C-H>'                      , 'which_key_ignore']          ,
    \ 'j' : ['<C-W><C-J>'                      , 'which_key_ignore']          ,
    \ 'k' : ['<C-W><C-K>'                      , 'which_key_ignore']          ,
    \ 'l' : ['<C-W><C-L>'                      , 'which_key_ignore']          ,
    \ 'Q' : ['q!'                              , 'which_key_ignore']          ,
    \ 'w' : ['w!'                              , 'which_key_ignore']          ,
    \ 'q' : ['q'                               , 'which_key_ignore']          ,
    \ 'll': ['bnext'                           , 'Next buffer']               ,
    \ 'hh': ['bprevious'                       , 'Previous buffer']           ,
    \ }

" WhichKey buffer
let g:which_key_map.b = {
    \ 'name' : '+buffer' ,
    \ 'b' : ['new'                             , 'New buffer (horizontal)']   ,
    \ 'v' : ['vnew'                            , 'New buffer (vertical)']     ,
    \ 'n' : ['enew'                            , 'New buffer (no split)']     ,
    \ 'd' : ['Bclose'                          , 'Close buffer']              ,
    \ 'c' : ['Bclose'                          , 'Close buffer']              ,
    \ 'l' : ['bnext'                           , 'Next buffer']               ,
    \ 'h' : ['bprevious'                       , 'Previous buffer']           ,
    \ 'a' : ['bufdo bd'                        , 'Close all buffers']         ,
    \ }

" WhichKey fzf
let g:which_key_map.f = {
    \ 'name' : '+fzf' ,
    \ 'g' : ['GFiles'                          , 'Search git files']          ,
    \ 'f' : ['Files'                           , 'Search all files']          ,
    \ 'b' : ['Buffers'                         , 'Search buffers']            ,
    \ 'l' : ['BLines'                          , 'Search lines']              ,
    \ 'h' : ['History'                         , 'Search history']            ,
    \ 'm' : ['Maps'                            , 'Search mappings']           ,
    \ 'c' : ['Commits'                         , 'Search commits']            ,
    \ 'r' : ['Rg'                              , 'Search in files']           ,
    \ }

" WhichKey git
let g:which_key_map.g = {
    \ 'name' : '+git' ,
    \ 's' : [':Git'                            , 'Open git']                  ,
    \ 'b' : [':Git blame'                      , 'View blame']                ,
    \ 'c' : [':Git commit'                     , 'Create commit']             ,
    \ 'd' : [':SignifyHunkDiff'                , 'View diff']                 ,
    \ 'n' : ['<plug>(signify-next-hunk)'       , 'Next hunk']                 ,
    \ 'p' : ['<plug>(signify-prev-hunk)'       , 'Previous hunk']             ,
    \ 'u' : [':SignifyHunkUndo'                , 'Undo hunk']                 ,
    \ }

" WhichKey spellcheck
let g:which_key_map.s = {
    \ 'name' : '+spell' ,
    \ 's' : [':setlocal spell!'                , 'Toggle spell check']        ,
    \ 'n' : [']s'                              , 'Next misspelling']          ,
    \ 'p' : ['[s'                              , 'Previous misspelling']      ,
    \ 'a' : ['zg'                              , 'Add to dictionary']         ,
    \ '?' : ['z='                              , 'Search in dictionary']      ,
    \ }

" WhichKey folding
let g:which_key_map.z = {
    \ 'name' : '+fold' ,
    \ 'a' : ['za'                      , 'Toggle current fold']               ,
    \ 'A' : ['zA'                      , 'Toggle all folds under cursor']     ,
    \ 'r' : ['zr'                      , 'Open one fold level in buffer']     ,
    \ 'R' : ['zR'                      , 'Open all folds']                    ,
    \ 'm' : ['zm'                      , 'Close one fold level in buffer']    ,
    \ 'M' : ['zM'                      , 'Close all folds']                   ,
    \ }
