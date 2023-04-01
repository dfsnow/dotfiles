call plug#begin('~/.vim/vim-plug')

" UI and colors
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'dracula/vim', { 'as': 'dracula' }

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Movement and formatting
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

" Neovim-specific stuff. Not used on systems with only vim
if has('nvim-0.7.0') && ($NVIM_EDITOR_CONFIG == "ADVANCED")

    " LSP and treesitter
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " UI and movement
    Plug 'folke/which-key.nvim'
    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
    Plug 'phaazon/hop.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'kosayoda/nvim-lightbulb'

    " Fuzzy search
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

    " Completion and snippets
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'onsails/lspkind.nvim'

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

    " GitHub Copilot
    Plug 'zbirenbaum/copilot.lua'
    Plug 'zbirenbaum/copilot-cmp'

endif

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Table of Contents
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sections:
"    -> General
"    -> Vim User Interface
"    -> Colors and Fonts
"    -> Files and Backups
"    -> Text, Tab, and Indent Related
"    -> Moving Around, Tabs, and Buffers
"    -> Editing Mappings
"    -> Spell Checking
"    -> Helper Functions
"    -> Miscellaneous
"    -> Vim Plugin Settings
"    -> Neovim Plugin Settings


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" How many lines of history vim has to remember
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
nmap <leader>W :x<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null
command Q :q!


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim User Interface
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

" Always show current position
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

" Make search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Turn magic on for regular expressions 
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
set guifont=JetBrainsMono\ Nerd\ Font:h14

" Set background color
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, Backups and Undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git, etc anyway
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, Tab, and Indent Related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable smart auto indent and line wrapping
set ai
set si
set wrap

" Keep text selected on indent
vnoremap < <gv
vnoremap > >gv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving Around, Tabs, and Buffers
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

" Terminal escaping
tmap <leader><Esc> <C-\><C-n>:q<CR>
tmap <leader>q <C-\><C-n>:q<CR>
tmap <leader><Tab> <C-\><C-n><c-W>w
tmap <leader><S-Tab> <C-\><C-n><c-W>W

" Open new buffers
map <leader>bh :new<cr>
map <leader>b_ :new<cr>
map <leader>bv :vnew<cr>
map <leader>b- :vnew<cr>
map <leader>bn :enew<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>
map <leader>bc :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Switch between buffers in windows
map <leader>ll :bnext<cr>
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

" Remap Vim 0 to first non-blank character
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
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.md,*.R,*.Rmd,*.qmd,*.css,*.html,*.yaml,*.toml :call CleanExtraSpaces()
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

" Remap enter and backspace in Normal mode
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {
nnoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
onoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
vnoremap <CR> }

" Replace word with last yank
nnoremap R diw"0P
vnoremap R "_d"0P"

" Decrease update time
set updatetime=100

" Language-specific fixes
let r_indent_align_args = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Commentary
nnoremap <leader>c :Commentary<cr>
vnoremap <leader>c :Commentary<cr>

" GitGutter
let g:gitgutter_map_keys = 0
nmap <leader>gg :GitGutterToggle<CR>
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
nmap <leader>gd :GitGutterDiff<CR>
nmap <leader>gf :GitGutterFold<CR>
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gn <Plug>(GitGutterNextHunk)
nmap <leader>gp <Plug>(GitGutterPrevHunk) 

" Git Fugitive
nmap <leader>go :Git<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gc :Git commit<CR>

" Dracula
let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula

" Lightline
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  if FugitiveHead() == ''
    return ''
  else
    return printf('+%d ~%d -%d', a, m, r)
endfunction

set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme'         : 'dracula',
    \ 'component_function'  : {
    \    'gitbranch': 'FugitiveHead',
    \    'gitstatus': 'GitStatus' }
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
    \   ['percent', 'lineinfo']                                               ,
    \   ['fileformat', 'fileencoding', 'filetype'] ]                          ,
    \ 'left'  : [
    \   ['mode', 'paste']                                                     ,
    \   ['gitbranch', 'gitstatus']                                            ,
    \   ['readonly', 'filename', 'modified'] ]                                ,
    \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neovim Plugin Settings
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
  window = { border = "single" },
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
    n = { "<cmd>setlocal wrap!<cr>"            , "Toggle word wrap"          },
    h = { "<C-W><C-H>"                         , "which_key_ignore"          },
    j = { "<C-W><C-J>"                         , "which_key_ignore"          },
    k = { "<C-W><C-K>"                         , "which_key_ignore"          },
    l = { "<C-W><C-L>"                         , "which_key_ignore"          },
    q = { "<cmd>q<cr>"                         , "which_key_ignore"          },
    Q = { "<cmd>q!<cr>"                        , "which_key_ignore"          },
    w = { "<cmd>w!<cr>"                        , "which_key_ignore"          },
    W = { "<cmd>x<cr>"                         , "which_key_ignore"          },
["?"]       = { "<cmd>FzfLua grep_project<cr>" , "Ripgrep files"             },
["/"]       = { "<cmd>FzfLua grep_curbuf<cr>"  , "Search current buffer"     },
["ll"]      = { "<cmd>bnext<cr>"               , "Next buffer"               },
["hh"]      = { "<cmd>bprevious<cr>"           , "Previous buffer"           },
["<Tab>"]   = { "<C-W>w"                       , "Next window"               },
["<Space>"] = { "za"                           , "Toggle current fold"       },
  }
}) 

wk.register({
  b = {
    name = "buffer",
    ["-"] = { "<cmd>new<cr>"                   , "which_key_ignore"          },
    ["_"] = { "<cmd>vnew<cr>"                  , "which_key_ignore"          },
    h = { "<cmd>new<cr>"                       , "New (horizontal)"          },
    v = { "<cmd>vnew<cr>"                      , "New (vertical)"            },
    n = { "<cmd>enew<cr>"                      , "New (no split)"            },
    c = { "<cmd>Bclose<cr>"                    , "Close"                     },
    d = { "<cmd>Bclose<cr>"                    , "which_key_ignore"          },
    a = { "<cmd>bufdo bd<cr>"                  , "Close all"                 },
    s = { "<cmd>FzfLua buffers<cr>"            , "Search buffers"            },
  },
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "lsp",
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Previous diagnostic" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<cr>"  , "Next diagnostic"     },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>"    , "Show references"     },
    R = { "<cmd>lua vim.lsp.buf.rename()<cr>"        , "Rename references"   },
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>"    , "Goto definition"     },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>"   , "Goto declaration"    },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Show implementations"},
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help" },
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>"         , "Show hover info"     },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>"   , "Show code actions"   },
    f = { 
      "<cmd>lua vim.lsp.buf.format { timeout_ms = 20000 }<cr>",
      "Format buffer"
    },
    s = {
      name = "search",
      r = { "<cmd>FzfLua lsp_references<cr>"          , "References"         },
      d = { "<cmd>FzfLua lsp_definitions<cr>"         , "Definitions"        },
      D = { "<cmd>FzfLua lsp_declarations<cr>"        , "Declarations"       },
      i = { "<cmd>FzfLua lsp_implementations<cr>"     , "Implementations"    },
      s = { "<cmd>FzfLua lsp_document_symbols<cr>"    , "Document symbols"   },
      S = { "<cmd>FzfLua lsp_workspace_symbols<cr>"   , "Workspace symbols"  },
      n = {
        "<cmd>FzfLua lsp_document_diagnostics<cr>",
        "Document diagnostics"
      },
    },
  },
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "search",
    g = { "<cmd>FzfLua git_files<cr>"                 , "Git files"          },
    f = { "<cmd>FzfLua files<cr>"                     , "All files"          },
    b = { "<cmd>FzfLua buffers<cr>"                   , "Buffers"            },
    l = { "<cmd>FzfLua grep_curbuf<cr>"               , "Current buffer"     },
    m = { "<cmd>FzfLua marks<cr>"                     , "Marks"              },
    h = { "<cmd>FzfLua command_history<cr>"           , "History"            },
    c = { "<cmd>FzfLua git_commits<cr>"               , "Commits"            },
    r = { "<cmd>FzfLua grep_project<cr>"              , "Ripgrep files"      },
    a = { "<cmd>FzfLua grep_project<cr>"              , "which_key_ignore"   },
    d = { "<cmd>FzfLua lsp_finder<cr>"                , "LSP options"        },
    s = { "<cmd>FzfLua spell_suggest<cr>"             , "Spellings"          },
  },
}, { prefix = "<leader>" })

wk.register({
  g = {
    name = "git",
    o = { "<cmd>Git<cr>"                       , "Open git"                  },
    b = { "<cmd>Git blame<cr>"                 , "View blame"                },
    c = { "<cmd>Git commit<cr>"                , "Create commit"             },
    g = { "<cmd>GitGutterToggle<cr>"           , "Toggle git signs"          },
    d = { "<cmd>GitGutterDiff<cr>"             , "View diff"                 },
    f = { "<cmd>GitGutterFold<cr>"             , "View modified lines"       },
    n = { "<Plug>(GitGutterNextHunk)"          , "Next hunk"                 },
    p = { "<Plug>(GitGutterPrevHunk)"          , "Previous hunk"             },
    u = { "<Plug>(GitGutterUndoHunk)"          , "Undo hunk"                 },
    s = { "<Plug>(GitGutterStageHunk)"         , "Stage hunk"                },
    h = { "<cmd>GitGutterLineHighlightsToggle<cr>", "Toggle line highlights" },
  },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "spell",
    s = { "<cmd>setlocal spell!<cr>"           , "Toggle spell check"        },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
["?"] = { "<cmd>FzfLua spell_suggest<cr>"      , "Search in dictionary"      },
  }
}, { prefix = "<leader>" })

wk.register({
  t = {
    name = "term",
    t = { "<cmd>ToggleTerm<cr>"                     , "Toggle current"       },
    v = { "<cmd>ToggleTerm direction=vertical<cr>"  , "New (vertical)"       },
    h = { "<cmd>ToggleTerm direction=horizontal<cr>", "New (horizontal)"     },
    f = { "<cmd>ToggleTerm direction=float<cr>"     , "New (float)"          },
    a = { "<cmd>ToggleTermToggleAll<cr>"            , "Toggle all"           },
}}, { prefix = "<leader>" })

wk.register({
  z = {
    name = "fold",
    a = { "za"                            , "Toggle current"                 },
    A = { "zA"                            , "Toggle all under cursor"        },
    r = { "zr"                            , "Open one level in buffer"       },
    R = { "zR"                            , "Open all"                       },
    m = { "zm"                            , "Close one level in buffer"      },
    M = { "zM"                            , "Close all"                      },
  },
}, { prefix = "<leader>" })


---------------------------------------------------------------
-- Diagnostics and LSP
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

-- Enable LSP hover info
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- Add borders to floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)


---------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------

require("nvim-treesitter.configs").setup {
  ensure_installed = { 
    "lua", "vim", "vimdoc",
    "rust", "c", "cpp", "go",
    "r", "python", "julia",
    "javascript", "html", "typescript",
    "toml", "yaml", "json",
    "bash", "awk", "jq",
    "gitcommit", "gitignore", "gitattributes",
    "dockerfile", "sql", "comment"
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}


---------------------------------------------------------------
-- Completion
---------------------------------------------------------------

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-p>'] = cmp.mapping.scroll_docs(-4),
    ['<C-n>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    })
  },
  sources = {
    { name = 'path',       max_item_count = 4},
    { name = 'nvim_lsp',   max_item_count = 9, keyword_length = 1 },
    { name = 'buffer',     max_item_count = 9, keyword_length = 2 },
    { name = "copilot",    max_item_count = 4 },
    { name = 'vsnip',      max_item_count = 5 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'calc' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      symbol_map = { Copilot = "" }
    })
  }
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
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
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
  tools = {
    hover_actions = {
      auto_focus = true,
    },
  },
  server = {
    -- These will overwrite the default actions on load
    on_attach = function(_, bufnr)
      vim.keymap.set(
        "n", "K",
        rt.hover_actions.hover_actions, { buffer = bufnr }
      )
      vim.keymap.set(
        "n", "<leader>dK",
        rt.hover_actions.hover_actions, { buffer = bufnr }
      )
      vim.keymap.set(
        "n", "<leader>da",
        rt.code_action_group.code_action_group, { buffer = bufnr }
      )
      wk.register({
        d = {
          name = "lsp",
          a = {
            "<cmd>lua rt.code_action_group.code_action_group<cr>",
            "View code actions"
          },
          K = {
            "<cmd>lua rt.hover_actions.hover_actions<cr>",
            "View hover actions"
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
})


---------------------------------------------------------------
-- Other Language Integration
---------------------------------------------------------------

require("lspconfig").r_language_server.setup{}
require("lspconfig").pyright.setup{}
require("lspconfig").html.setup{}
require("lspconfig").cssls.setup{}


---------------------------------------------------------------
-- Other Plugins 
---------------------------------------------------------------

-- GitHub Copilot
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
require("copilot_cmp").setup()

-- indent-blankline
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"
require("indent_blankline").setup({
    show_current_context = true,
    show_end_of_line = true,
    space_char_blankline = " ",
})

-- fzf-lua
require("fzf-lua").setup({
  fzf_opts = {
    ['--layout'] = 'default'
  }
})

-- nvim-lightbulb
vim.fn.sign_define('LightBulbSign', {
  text = "A",
  texthl = "A",
  linehl="A",
  numhl="A"
})
require('nvim-lightbulb').setup({
  autocmd = { enabled = true },
})

-- Hop
require("hop").setup()
local hop = require("hop")
local directions = require("hop.hint").HintDirection
vim.keymap.set("n", "<space>", "<cmd>HopWord<cr>")
vim.keymap.set('', 'f', function()
  hop.hint_char1({
    direction = directions.AFTER_CURSOR,
    current_line_only = true
  })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ 
    direction = directions.BEFORE_CURSOR,
    current_line_only = true
  })
end, {remap=true})

-- ToggleTerm
require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return math.floor(vim.o.lines * 0.4)
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  float_opts = {
    border = 'curved',
    height = math.floor(vim.o.lines * 0.85),
    width = math.floor(vim.o.columns * 0.80)
  }
})

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

" fzf-lua
nnoremap <C-t> :FzfLua files<CR>
nnoremap <C-r> :FzfLua command_history<CR>
nnoremap ? :FzfLua grep_curbuf<CR>
nnoremap <leader>? :FzfLua grep_project<CR>

" ToggleTerm
nnoremap <C-Space> :ToggleTermSendCurrentLine<CR><CR>
xnoremap <C-Space> :ToggleTermSendVisualLines<CR>`><CR>
vnoremap <C-Space> :ToggleTermSendVisualSelection<CR>`><CR>

endif
