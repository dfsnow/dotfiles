return {
  {
    "neovim/nvim-lspconfig",
    ft = { 
      "r", "rmd", "quarto", "python",
      "html", "css", "scss", "less" 
    },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.r_language_server.setup{
        filetypes = { "r", "rmd", "quarto" }
      }
      lspconfig.pyright.setup{}
      lspconfig.html.setup{}
      lspconfig.cssls.setup{}
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
        python = { "pylint", "flake8" },
        yaml = { "yamllint", "actionlint" },
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
    end
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local wk = require("which-key")
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
    end
  }
}
