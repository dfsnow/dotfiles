return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    build = ":TSUpdate",
    ft = require("config.filetypes").treesitter_ft,
    config = function()
      local filetypes = require("config.filetypes")
      local helpers = require("config.helpers")
      require("nvim-treesitter.configs").setup({
        ensure_installed = filetypes.treesitter_parsers,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
          disable = helpers.is_big_file
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
    version = "*",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "jpalardy/vim-slime"
    },
    ft = require("config.filetypes").smart_send_ft,
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
    end
  }
}
