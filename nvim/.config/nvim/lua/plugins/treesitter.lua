return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    ft = treesitter_ft,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = treesitter_parsers,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
          disable = is_big_file
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
