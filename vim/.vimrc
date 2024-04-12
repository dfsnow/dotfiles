"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mapleader = ","
nmap <leader>w :w!<cr>
nmap <leader>W :x<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :qall!<cr>

command Q :q!

set history=500
set autoread
set encoding=utf8
set ffs=unix,dos,mac
set nobackup nowb noswapfile
set updatetime=100

let g:r_indent_align_args = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set so=7
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set completeopt=menuone,noselect,noinsert
set shortmess+=c
set ruler
set hidden
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ic sc
set hlsearch incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells novisualbell t_vb= tm=500
set number
set cursorline
set colorcolumn=80
set signcolumn=yes
set ai si nowrap
set foldcolumn=1
set foldmethod=indent
set foldlevel=99
set laststatus=2
set noshowmode
set timeoutlen=300
set termguicolors
syntax enable


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Windows and Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set splitright
set splitbelow

nmap <leader><Space> za
vmap <leader><Space> za
nmap <leader><S-Space> zA
vmap <leader><S-Space> zA

nmap <leader>j <C-W><C-J>
nmap <leader>k <C-W><C-K>
nmap <leader>l <C-W><C-L>
nmap <leader>h <C-W><C-H>
nmap <leader><Tab> <C-W>w
nmap <leader><S-Tab> <C-W>W

tmap <Esc><Esc> <C-\><C-n>

nmap <leader>_ :new<cr>
nmap <leader>- :vnew<cr>
nmap <leader>bb :enew<cr>
nmap <leader>bn :enew<cr>
nmap <leader>x :bdelete!<cr>
nmap <leader>bc :Bclose<cr>

nmap <Tab> :bnext<cr>
nmap <S-Tab> :bprevious<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edited position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Remaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap 0 ^
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {
nnoremap <expr> <CR> empty(&buftype) ? "}" : "<CR>"
onoremap <expr> <CR> empty(&buftype) ? "}" : "<CR>"
vnoremap <CR> }

" Replace word with last yank
nnoremap R diw"0P
vnoremap R "_d"0P"

" Keep text selected on indent
vnoremap < <gv
vnoremap > >gv
vmap y ygv<esc>

" Copy and paste to system clipboard
vmap <leader>y "+ygv<esc>
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Redo to capital u
nnoremap U <C-r>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell Checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>ss :setlocal spell!<cr>
nmap <leader>sn ]s
nmap <leader>sp [s
nmap <leader>sa zg
nmap <leader>s? z=

set spelllang=en
set spellfile=$HOME/dotfiles/spell/en.utf-8.add


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Delete trailing white space on save
fun! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg("/")
  silent! %s/\s\+$//e
  call setpos(".", save_cursor)
  call setreg("/", old_query)
endfun

if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.md,*.R,*.Rmd,*.qmd,*.css,*.html,*.yaml,*.toml :call CleanExtraSpaces()
endif
