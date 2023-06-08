call plug#begin("~/.vim/vim-plug")

if has("nvim-0.8.0") && ($NVIM_EDITOR_CONFIG == "ADVANCED")

    " Git Integration
    Plug 'tpope/vim-fugitive'
    Plug 'lewis6991/gitsigns.nvim'

    " Diagnostics and Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

    " UI and Colors
    Plug 'Mofiqul/dracula.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kosayoda/nvim-lightbulb'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'akinsho/toggleterm.nvim', { 'tag' : '*' }
    Plug 'elihunter173/dirbuf.nvim'

    " Movement and Search
    Plug 'phaazon/hop.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope-ui-select.nvim'

    " Completion and Snippets
    Plug 'hrsh7th/nvim-cmp'
    Plug 'onsails/lspkind.nvim'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'zbirenbaum/copilot.lua'

    " Completion Sources
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-calc'
    Plug 'zbirenbaum/copilot-cmp'
    
    " Language Integration
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'jose-elias-alvarez/null-ls.nvim'
    Plug 'simrat39/rust-tools.nvim'

    " WhichKey
    Plug 'folke/which-key.nvim'

else

  " Use vim dracula as a backup for nvim version
  Plug 'dracula/vim', { 'as': 'dracula' }

endif

" tpope base for only-vim systems
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Table of Contents
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sections:
"    -> General
"    -> User Interface
"    -> Windows and Buffers
"    -> Remaps
"    -> Spell Checking
"    -> Helper Functions
"    -> Neovim Settings
"       -- Git Integration
"       -- LSP and Treesitter
"       -- UI and Colors
"       -- Movement and Search
"       -- Completion and Snippets
"       -- Language Integration
"       -- WhichKey Remaps
"       -- Additional Remaps
"    -> Vim Plugin Settings


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mapleader = ","
nmap <leader>w :w!<cr>
nmap <leader>W :x<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>

" :W sudo saves the file
command W w !sudo tee % > /dev/null
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
set ai si wrap
set foldcolumn=1
set foldmethod=indent
set foldlevel=99
set laststatus=2
set noshowmode
set timeoutlen=300
syntax enable



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Windows and Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set splitright
set splitbelow

nmap <leader>j <C-W><C-J>
nmap <leader>k <C-W><C-K>
nmap <leader>l <C-W><C-L>
nmap <leader>h <C-W><C-H>
nmap <Tab> <C-W>w
nmap <S-Tab> <C-W>W

tmap <leader><Esc> <C-\><C-n>:q<CR>
tmap <leader>q <C-\><C-n>:q<CR>
tmap <leader><Tab> <C-\><C-n><c-W>w
tmap <leader><S-Tab> <C-\><C-n><c-W>W

nmap <leader>bh :new<cr>
nmap <leader>b_ :new<cr>
nmap <leader>bv :vnew<cr>
nmap <leader>b- :vnew<cr>
nmap <leader>bn :enew<cr>

nmap <leader>bd :Bclose<cr>
nmap <leader>bc :Bclose<cr>
nmap <leader>ba :bufdo bd<cr>

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neovim Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only setup on machines with neovim. This lets this config
" remain useable on remote machines where installing a ton
" of dependencies is undesirable
if has("nvim-0.8.0") && ($NVIM_EDITOR_CONFIG == "ADVANCED")

lua <<EOF

---------------------------------------------------------------
-- Git Integration
---------------------------------------------------------------

require("gitsigns").setup({
  signs = {
    add          = { text = "+" },
    change       = { text = "~" },
    delete       = { text = "-" },
    topdelete    = { text = "‾" },
    changedelete = { text = "_" },
    untracked    = { text = "┆" },
  },
})


---------------------------------------------------------------
-- Diagnostics and Treesitter
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

-- Add rounded borders to floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)

require("nvim-treesitter.configs").setup{
  ensure_installed = { 
    "lua", "vim",
    "rust", "c", "cpp", "go",
    "r", "python", "julia",
    "javascript", "html", "typescript",
    "toml", "yaml", "json",
    "bash", "awk", "jq",
    "markdown", "markdown_inline",
    "gitcommit", "gitignore", "gitattributes",
    "dockerfile", "sql", "comment"
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" }
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader><CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>"
    }
  }
}


---------------------------------------------------------------
-- UI and Colors
---------------------------------------------------------------

local dracula = require("dracula")
dracula.setup({
  colors = { nontext = "#474e57" }, -- default is too low contrast
  overrides = {
    WhichKeyDesc = { fg = dracula.colors().bright_white },
    WhichKeyGroup = { fg = dracula.colors().pink },
    FloatBorder = { fg = dracula.colors().bright_white },
    FoldColumn = { fg = dracula.colors().comment },
    ColorColumn = { bg = dracula.colors().black },
    CmpItemAbbr = { fg = dracula.colors().bright_white, bg = nil },
    CmpItemAbbrMatch = { fg = dracula.colors().bright_green },
    GitSignsChange = { fg = dracula.colors().orange },
    GitSignsChangeLn = { fg = dracula.colors().orange },
    TelescopePromptBorder = { fg = dracula.colors().bright_white },
    TelescopePreviewBorder = { fg = dracula.colors().bright_white },
    TelescopeResultsBorder = { fg = dracula.colors().bright_white },
    TelescopeSelection = { fg = dracula.colors().bright_white },
    TelescopeMatching = { fg = dracula.colors().bright_green }
  }
})

require("lualine").setup({
  options = { icons_enabled = false },
  extensions = { "toggleterm", "fugitive" },
  tabline = {
    lualine_a = {
      { "buffers", symbols = { modified = "[+]", alternate_file = "" } }
    }
  }
})

require("nvim-lightbulb").setup({ autocmd = { enabled = true }, })
vim.fn.sign_define("LightBulbSign", {
  text = "A",
  texthl = "A",
  linehl = "A",
  numhl = "A"
})

vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"
require("indent_blankline").setup({
  show_current_context = true,
  show_end_of_line = true,
  space_char_blankline = " ",
})

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
    width = math.floor(vim.o.columns * 0.90)
  },
  shade_terminals = false,
  highlights = {
    Normal = {
      guibg = dracula.colors().bg
    }
  }
})


---------------------------------------------------------------
-- Movement and Search
---------------------------------------------------------------

require("hop").setup()

actions = require("telescope.actions")
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").setup({
  defaults = {
    file_ignore_patterns = { ".git", "renv" },
    layout_strategy = "flex",
    layout_config = {
      horizontal = { preview_cutoff = 0, width = 0.90, height = 0.85 },
      vertical = { preview_cutoff = 0, width = 0.90 },
    },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<Esc>"] = actions.close,
        ["<C-j>"] = { actions.move_selection_previous, type = "action" },
        ["<C-k>"] = { actions.move_selection_next, type = "action" }
      }
    },
    hidden = true
  },
  pickers = {
    find_files = {
      hidden = true
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_cursor()
    }
  }
})


---------------------------------------------------------------
-- Completion and Snippets
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

-- require("copilot").setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()


---------------------------------------------------------------
-- Language Integration
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

local rt = require("rust-tools")
rt.setup({
  tools = {
    hover_actions = {
      auto_focus = true,
    },
  },
  server = {
    -- These will overwrite the default mappings on load
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
-- WhichKey Remaps
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

-- Load custom which-key mappings from file
require("mappings")


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

EOF

" Add diagnostic floating window
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Automatically highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup = "IncSearch", timeout = 700 }

" Replace indent folding with treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>c :Commentary<cr>
vmap <leader>c :Commentary<cr>

let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula " must load after the nvim plugin
