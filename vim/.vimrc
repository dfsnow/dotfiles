call plug#begin('~/.vim/vim-plug')

" UI and colors
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'dracula/vim', { 'as': 'dracula' }

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Formatting
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'

" Movement and search
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Neovim-specific stuff. Don't use on systems with only vim
if has('nvim-0.7.0') && ($NVIM_EDITOR_CONFIG == "ADVANCED")

    " LSP and treesitter setup
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Neovim which-key and terminal 
    Plug 'folke/which-key.nvim'
    Plug 'voldikss/vim-floaterm'

    " Completion frameworks and snippets
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'rafamadriz/friendly-snippets'

    " Completion sources
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'                             
    Plug 'hrsh7th/cmp-path'                              
    Plug 'hrsh7th/cmp-buffer'                            
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-calc'
    
    " Language-specific packages
    Plug 'simrat39/rust-tools.nvim'

endif

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
"    -> Plugin Settings
"    -> Neovim Settings


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

" Show sign/diagnostic column
set signcolumn=yes


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
nnoremap <Tab>   <c-W>w
nnoremap <S-Tab> <c-W>W

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

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
map <space> <plug>(easymotion-bd-f)
nmap <space> <plug>(easymotion-overwin-f)

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
nmap <leader>ff :Files<CR>
nmap <leader>fg :GFiles<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fh :History<CR>
nmap <leader>fl :BLines<CR>
nmap <leader>fm :Maps<CR>
nmap <leader>fc :Commits<CR>
nmap <leader>fr :Rg<CR>
nnoremap <C-t> :Files<CR>
nnoremap ? :Rg<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neovim Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only setup LSP and language support on machines with neovim
" This lets this config remain useable on remote machines where
" installing a ton of dependencies is undesirable
if has('nvim-0.7.0') && ($NVIM_EDITOR_CONFIG == "ADVANCED")

lua <<EOF

---------------------------------------------------------------
-- WhichKey
---------------------------------------------------------------

-- Configure which-key mappings
local wk = require("which-key")
wk.register(mappings, opts)
wk.setup {
  plugins = {
    marks = true,
    registers = false,
    spelling = {
      enabled = true,
      suggestions = 10,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = false,
      z = true,
      g = true,
    },
  },
  key_labels = {
    ["<space>"] = "SPACE",
    ["<cr>"]    = "ENTER",
    ["<Tab>"]   = "TAB",
  },
}

wk.register({
  ["<leader>"] = {
    x = { "<cmd>lua toggleAutoCmp()<cr>"       , "Toggle completion"         },
    c = { "<cmd>Commentary<cr>"                , "Toggle comment"            },
    v = { "<cmd>setlocal paste!<cr>"           , "Toggle paste mode"         },
    h = { "<C-W><C-H>"                         , "which_key_ignore"          },
    j = { "<C-W><C-J>"                         , "which_key_ignore"          },
    k = { "<C-W><C-K>"                         , "which_key_ignore"          },
    l = { "<C-W><C-L>"                         , "which_key_ignore"          },
    q = { "<cmd>q<cr>"                         , "which_key_ignore"          },
    Q = { "<cmd>q!<cr>"                        , "which_key_ignore"          },
    w = { "<cmd>w!<cr>"                        , "which_key_ignore"          },
["?"]       = { "<cmd>Rg<cr>"                  , "Search in all files"       },
["ll"]      = { "<cmd>bnext<cr>"               , "Next buffer"               },
["hh"]      = { "<cmd>bprevious<cr>"           , "Previous buffer"           },
["<Tab>"]   = { "<C-W>w"                       , "Next window"               },
["<Space>"] = { "za"                           , "Toggle current fold"       },
  }
}) 

wk.register({
  b = {
    name = "buffer",
    b = { "<cmd>new<cr>"                       , "New buffer (horizontal)"   },
    v = { "<cmd>vnew<cr>"                      , "New buffer (vertical)"     },
    n = { "<cmd>enew<cr>"                      , "New buffer (no split)"     },
    d = { "<cmd>Bclose<cr>"                    , "Close buffer"              },
    c = { "<cmd>Bclose<cr>"                    , "Close buffer"              },
    l = { "<cmd>bnext<cr>"                     , "Next buffer"               },
    h = { "<cmd>bprevious<cr>"                 , "Previous buffer"           },
    a = { "<cmd>bufdo bd<cr>"                  , "Close all buffers"         },
  },
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "diag",
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Previous diagnostic" },
    n = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Next diagnostic"     },
    d = { "<cmd>lua vim.diagnostic.open_float()<cr>" , "Show diagnostic"     },
  },
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "search",
    g = { "<cmd>GFiles<cr>"                    , "Search git files"          },
    f = { "<cmd>Files<cr>"                     , "Search all files"          },
    b = { "<cmd>Buffers<cr>"                   , "Search buffers"            },
    l = { "<cmd>BLines<cr>"                    , "Search lines"              },
    m = { "<cmd>Maps<cr>"                      , "Search mappings"           },
    h = { "<cmd>History<cr>"                   , "Search history"            },
    c = { "<cmd>Commits<cr>"                   , "Search commits"            },
    r = { "<cmd>Rg<cr>"                        , "Search in files"           },
  },
}, { prefix = "<leader>" })

wk.register({
  g = {
    name = "git",
    s = { "<cmd>Git<cr>"                       , "Open git"                  },
    b = { "<cmd>Git blame<cr>"                 , "View blame"                },
    c = { "<cmd>Git commit<cr>"                , "Create commit"             },
    d = { "<cmd>SignifyHunkDiff<cr>"           , "View diff"                 },
    n = { "<plug>(signify-next-hunk)"          , "Next hunk"                 },
    p = { "<plug>(signify-prev-hunk)"          , "Previous hunk"             },
    u = { "<cmd>SignifyHunkUndo<cr>"           , "Undo hunk"                 },
    g = { "<cmd>SignifyToggle<cr>"             , "Toggle git gutter"         },
  },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "spell",
    s = { "<cmd>setlocal spell!<cr>"           , "Toggle spell check"        },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
["?"] = { "z="                                 , "Search in dictionary"      },
  },
}, { prefix = "<leader>" })

wk.register({
  t = {
    name = "term",
    t = { "<cmd>FloatermToggle term<cr>"       , "Toggle terminal"           },
    k = { "<cmd>FloatermKill term<cr>"         , "Kill terminal"             },
    q = { "<cmd>FloatermKill!<cr>"             , "Kill all terminals"        },
    n = {
  "<cmd>FloatermNew --name=term --height=0.9 --width=0.8 --autoclose=2 <cr>"  ,
  "Open new terminal"                                                        },
}}, { prefix = "<leader>" })

wk.register({
  z = {
    name = "fold",
    a = { "za"                            , "Toggle current fold"            },
    A = { "zA"                            , "Toggle all folds under cursor"  },
    r = { "zr"                            , "Open one fold level in buffer"  },
    R = { "zR"                            , "Open all folds"                 },
    m = { "zm"                            , "Close one fold level in buffer" },
    M = { "zM"                            , "Close all folds"                },
  },
}, { prefix = "<leader>" })


---------------------------------------------------------------
-- Diagnostic
---------------------------------------------------------------

-- Add floating windows for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = ''
  },
})


---------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------

require('nvim-treesitter.configs').setup {
  ensure_installed = { 
    "lua", "rust", "r", "python", "javascript", "json",
    "dockerfile", "gitcommit", "gitignore", "gitattributes",
    "toml", "yaml", "bash", "vim", "awk"
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
}


---------------------------------------------------------------
-- Completion
---------------------------------------------------------------

local cmp = require'cmp'
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  },
})

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.scroll_docs(-4),
    ['<C-n>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    })
  },
  sources = {
    { name = 'path',       max_item_count = 4, keyword_length = 2 },
    { name = 'nvim_lsp',   max_item_count = 9, keyword_length = 3 },
    { name = 'buffer',     max_item_count = 9, keyword_length = 2 },
    { name = 'vsnip',      max_item_count = 5 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'calc' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        vsnip = '⋗',
        buffer = 'Ω',
        path = './',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})

-- Toggle autocompletion
vim.g.cmp_toggle_flag = true
function toggleAutoCmp()
  local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
  if next_cmp_toggle_flag then
    print("Completion on")
  else
    print("Completion off")
  end
  if next_cmp_toggle_flag then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  end
end


---------------------------------------------------------------
-- Rust Integration
---------------------------------------------------------------

-- Load rust-tools and LSP integration
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<Leader>r", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      wk.register({
        ["<leader>"] = {
          a = { "<cmd>lua rt.hover_actions.hover_actions<cr>", "View code actions" },
          r = { "<cmd>lua rt.code_action_group.code_action_group<cr>", "View hover actions" },
        },
      })
    end,
  },
})


---------------------------------------------------------------
-- R Integration
---------------------------------------------------------------
require'lspconfig'.r_language_server.setup{}


EOF

" Add diagnostic floating window
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Completion options
set completeopt=menuone,noselect,noinsert
set shortmess+=c

" Treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Show which-key faster
set timeoutlen=300

" Floaterm
tmap <Esc> <C-\><C-n>:q<CR>

endif

" Fix rust-tools hover/code actions
" Python integration
" Rust, python, R formatters
