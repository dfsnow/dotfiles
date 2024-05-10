return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "rust", "c", "cpp", "go",
          "r", "python", "julia",
          "javascript", "html", "typescript",
          "toml", "yaml", "json", "terraform",
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
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        }
      })

      --Replace indent folding with treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    deps = {
      "nvim-treesitter/nvim-treesitter",
      "jpalardy/vim-slime"
    },
    ft = { "python", "r", "julia", "lua" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer"
          }
        }
      })
      -- Adds a buffer local mapping to send the outer container (usually a
      -- function or class definition) to a REPL using vim-slime
      vim.cmd([[nmap <buffer> <leader><cr> v;<Plug>SlimeRegionSendgv<esc>]])
    end
  }
}
