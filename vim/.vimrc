call plug#begin('~/.vim/vim-plug')

" UI and colors
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'dracula/vim', { 'as': 'dracula' }

" Movement and formatting
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

" Neovim-specific stuff. Not used on systems with only vim
if has("nvim-0.8.0") && ($NVIM_EDITOR_CONFIG == "ADVANCED")

    " Git integration
    Plug 'tpope/vim-fugitive'
    Plug 'lewis6991/gitsigns.nvim'

    " LSP and treesitter
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " UI and movement
    Plug 'phaazon/hop.nvim'
    Plug 'folke/which-key.nvim'
    Plug 'kosayoda/nvim-lightbulb'
    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
    Plug 'lukas-reineke/indent-blankline.nvim'

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
    Plug 'nvim-lua/plenary.nvim'
    Plug 'jose-elias-alvarez/null-ls.nvim'
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
"    -> User Interface
"    -> Clipboard Integration
"    -> Moving Around, Tabs, and Buffers
"    -> Remaps
"    -> Spell Checking
"    -> Helper Functions
"    -> Vim Plugin Settings
"    -> Neovim Settings
"       -- Git Integration
"       -- Diagnostics and LSP
"       -- Treesitter
"       -- Completion
"       -- Rust Integration
"       -- Other Language Integration
"       -- Other Plugins 
"       -- Additional Remaps
"       -- WhichKey


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remember more command history
set history=500

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
let g:mapleader = ","

" Fast quitting and saving
nmap <leader>w :w!<cr>
nmap <leader>W :x<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>

" :W sudo saves the file
command W w !sudo tee % > /dev/null
command Q :q!

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git, etc anyway
set nobackup nowb noswapfile

" Decrease update time
set updatetime=100

" Language-specific fixes
let g:r_indent_align_args = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Ignore files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Completion options
set completeopt=menuone,noselect,noinsert
set shortmess+=c

" Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ic sc

" Highlight search results and search incrementally
set hlsearch incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Turn magic on for regular expressions 
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells novisualbell t_vb= tm=500

" Show the line number
set number

" Show a highlight on the cursorline
set cursorline

" Show the 80 char column
set colorcolumn=80

" Show sign/diagnostic column
set signcolumn=yes

" Enable smart auto indent and line wrapping
set ai si wrap

" Enable folding
set foldcolumn=1
set foldmethod=indent
set foldlevel=99

" Always show the status bar
set laststatus=2
set noshowmode

" Enable syntax highlighting
syntax enable

" Show leader menus faster
set timeoutlen=300


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clipboard Integration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Copy to system clipboard
vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy

" Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving Around, Tabs, and Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Split new buffers to the right
set splitright
set splitbelow

" Window movement with leader
nmap <leader>j <C-W><C-J>
nmap <leader>k <C-W><C-K>
nmap <leader>l <C-W><C-L>
nmap <leader>h <C-W><C-H>
nmap <Tab> <C-W>w
nmap <S-Tab> <C-W>W

" Terminal escaping
tmap <leader><Esc> <C-\><C-n>:q<CR>
tmap <leader>q <C-\><C-n>:q<CR>
tmap <leader><Tab> <C-\><C-n><c-W>w
tmap <leader><S-Tab> <C-\><C-n><c-W>W

" Open new buffers
nmap <leader>bh :new<cr>
nmap <leader>b_ :new<cr>
nmap <leader>bv :vnew<cr>
nmap <leader>b- :vnew<cr>
nmap <leader>bn :enew<cr>

" Close the current buffer
nmap <leader>bd :Bclose<cr>
nmap <leader>bc :Bclose<cr>

" Close all the buffers
nmap <leader>ba :bufdo bd<cr>

" Switch between buffers in windows
nmap <leader>ll :bnext<cr>
nmap <leader>hh :bprevious<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Remaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap 0 to first non-blank character
nmap 0 ^

" Remap enter and backspace in Normal mode
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {
nnoremap <expr> <CR> empty(&buftype) ? '}' : "<CR>"
onoremap <expr> <CR> empty(&buftype) ? '}' : "<CR>"
vnoremap <CR> }

" Replace word with last yank
nnoremap R diw"0P
vnoremap R "_d"0P"

" Keep text selected on indent
vnoremap < <gv
vnoremap > >gv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell Checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle spell checking
nmap <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
nmap <leader>sn ]s
nmap <leader>sp [s
nmap <leader>sa zg
nmap <leader>s? z=

" Spellfile language and location
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Commentary
nmap <leader>c :Commentary<cr>
vmap <leader>c :Commentary<cr>

" Dracula
let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula

" Lightline
function! GitStatus()
  if exists("b:gitsigns_status_dict")
    let dict = b:gitsigns_status_dict
    let added = get(dict, 'added', '')
    let changed = get(dict, 'changed', '')
    let removed = get(dict, 'removed', '')
    return printf("+%d ~%d -%d", added, changed, removed)
  else
    return ""
  endif
endfunction

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
" => Neovim Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only setup LSP and language support on machines with neovim
" This lets this config remain useable on remote machines where
" installing a ton of dependencies is undesirable
if has("nvim-0.8.0") && ($NVIM_EDITOR_CONFIG == "ADVANCED")

lua <<EOF

---------------------------------------------------------------
-- Git Integration
---------------------------------------------------------------

require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '-' },
    topdelete    = { text = '‾' },
    changedelete = { text = '_' },
    untracked    = { text = '┆' },
  },
}


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
    border = "rounded",
    source = "always",
    header = "",
    prefix = ""
  },
})

-- Add borders to floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)


---------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------

require("nvim-treesitter.configs").setup{
  ensure_installed = { 
    "lua", "vim",
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
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
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
    ["<C-p>"] = cmp.mapping.scroll_docs(-4),
    ["<C-n>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    })
  },
  sources = {
    { name = "path",       max_item_count = 4},
    { name = "nvim_lsp",   max_item_count = 9, keyword_length = 1 },
    { name = "buffer",     max_item_count = 9, keyword_length = 2 },
    { name = "copilot",    max_item_count = 4 },
    { name = "vsnip",      max_item_count = 5 },
    { name = "nvim_lsp_signature_help" },
    { name = "calc" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
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
      wk.register({
        d = {
          name = "lsp",
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

local lspconfig = require("lspconfig")
lspconfig.r_language_server.setup{}
lspconfig.pyright.setup{}
lspconfig.html.setup{}
lspconfig.cssls.setup{}

local null_ls = require("null-ls")
null_ls.setup({ default_timeout = 20000 })
null_ls.register({ 
  null_ls.builtins.code_actions.shellcheck,
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.formatting.shfmt.with({
    extra_args = { "-i", "4", "-bn", "-sr", "-p", "-ci" }
  })
})
null_ls.register({ 
  null_ls.builtins.diagnostics.sqlfluff,
  null_ls.builtins.formatting.sqlfluff
})
null_ls.register({ 
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.autopep8,
  null_ls.builtins.formatting.styler,
  null_ls.builtins.formatting.jq
})


---------------------------------------------------------------
-- Other Plugins 
---------------------------------------------------------------

-- GitHub Copilot
-- require("copilot").setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()

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
require("fzf-lua").setup({ fzf_opts = { ["--layout"] = "default" } })

-- nvim-lightbulb
require("nvim-lightbulb").setup({ autocmd = { enabled = true }, })
vim.fn.sign_define("LightBulbSign", {
  text = "A",
  texthl = "A",
  linehl = "A",
  numhl = "A"
})

-- Hop
require("hop").setup()
local hop = require("hop")
local directions = require("hop.hint").HintDirection

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
    border = "curved",
    height = math.floor(vim.o.lines * 0.85),
    width = math.floor(vim.o.columns * 0.80)
  }
})


---------------------------------------------------------------
-- Additional Remaps
---------------------------------------------------------------

-- Proper indentation on empty lines
vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- No yanking empty lines
vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })

-- Better, space-aware line joins
vim.keymap.set("n", "J", function()
  vim.cmd("normal! mzJ")
  local col = vim.fn.col(".")
  local context = string.sub(vim.fn.getline("."), col - 1, col + 1)
  if context == ") ." or context == ") :" or context:match("%( .") or context:match(". ,") or context:match("%w %.") then
    vim.cmd("undojoin | normal! x")
  elseif context == ",)" then
    vim.cmd("undojoin | normal! hx")
  end
  vim.cmd("normal! `z")
end)


---------------------------------------------------------------
-- WhichKey
---------------------------------------------------------------

local wk = require("which-key")
wk.register(mappings, opts)
wk.setup{
  plugins = {
    marks = true,
    registers = true,
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
    ["<space>"]    = "SPC",
    ["<cr>"]       = "RET",
    ["<CR>"]       = "RET",
    ["<Tab>"]      = "TAB",
    ["<S-Tab>"]    = "S-TAB",
    ["<leader>"]   = "LDR",
    ["<c-w>"]      = "C-w",
    ["<C-R>"]      = "C-r",
    ["<C-T>"]      = "C-f",
    ["<C-A>"]      = "C-a",
    ["<C-X>"]      = "C-x",
  },
}

wk.register({
  f = { 
    function()
      hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true
      })
    end
    , "Hop forward"
  },
  F = { 
    function()
      hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true
      })
    end
    , "Hop backward"
  },
})

-- Load custom which-key mappings
require("mappings")

EOF

" Add diagnostic floating window
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

endif
