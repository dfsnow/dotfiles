return {
  {
    "neovim/nvim-lspconfig",
    ft = {
      "r", "rmd", "quarto", "python",
      "html", "css", "scss", "less",
      "yaml", "lua"
    },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.r_language_server.setup {
        filetypes = { "r", "rmd", "quarto" }
      }
      lspconfig.pyright.setup {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { "*" },
            }
          }
        }
      }
      lspconfig.ruff_lsp.setup {}
      lspconfig.lua_ls.setup {}
      lspconfig.html.setup {}
      lspconfig.cssls.setup {}
      lspconfig.yamlls.setup {}
    end
  },

  {
    "stevearc/conform.nvim",
    ft = { "sh", "python", "json" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          sh = { "shfmt" },
          python = { "isort", "autopep8" },
          json = { "jq" },
        },
      })
      local util = require("conform.util")
      util.add_formatter_args(
        require("conform.formatters.shfmt"),
        { "-i", "4", "-bn", "-sr", "-p", "-ci" }
      )
      local wk = require("which-key")
      wk.register({
        d = {
          name = "lsp",
          F = {
            "<cmd>lua require('conform').format()<cr>",
            "Format buffer"
          },
        },
      }, { prefix = "<leader>" })
    end
  },

  {
    "mfussenegger/nvim-lint",
    ft = { "sh", "sql", "python", "yaml", "dockerfile", "markdown" },
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint" }
      }
      local wk = require("which-key")
      wk.register({
        d = {
          name = "lsp",
          L = {
            "<cmd>lua require('lint').try_lint()<cr>",
            "Lint buffer"
          },
        },
      }, { prefix = "<leader>" })

      -- Automatically lint on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end
      })
    end
  },

  {
    "folke/trouble.nvim",
    branch = "dev",
    opts = {
      focus = true,
      keys = {
        ["<Esc>"] = "close"
      }
    }
  }
}
