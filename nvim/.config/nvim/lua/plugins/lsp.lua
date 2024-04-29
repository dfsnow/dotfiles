return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Language servers
        "bashls",
        "cssls",
        "dockerls",
        "docker_compose_language_service",
        "html",
        "lua_ls",
        "pyright",
        -- "r_language_server", Not installed by default, too heavy
        "ruff",
        "ruff_lsp",
        "rust_analyzer",
        "yamlls",
        -- Formatters
        "jq",
        "shfmt",
        "sqlfluff",
        "yamlfmt",
        -- Linters
        "actionlint",
        "gitlint",
        "hadolint",
        "shellcheck",
        "sqlfluff",
        "stylelint",
        "markdownlint",
        "yamllint"
      }
    }
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          width = 0.88,
          height = 0.75
        }
      })
      require("mason-lspconfig").setup({})
      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({})
      lspconfig.cssls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.docker_compose_language_service.setup({})
      lspconfig.html.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.pyright.setup({
        settings = {
          pyright = {
            disableOrganizeImports = true,
            disableTaggedHints = true
          },
          python = {
            analysis = {
              diagnosticSeverityOverrides = {
                reportUndefinedVariable = "none"
              }
            }
          }
        }
      })
      lspconfig.r_language_server.setup({
        filetypes = { "r", "rmd", "quarto" }
      })
      lspconfig.ruff_lsp.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.yamlls.setup({})
    end
  },

  {
    "stevearc/conform.nvim",
    ft = {
      "json",
      "sh", "bash",
      "sql",
      "yaml"
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          json = { "jq" },
          sh = { "shfmt" }, bash = { "shfmt" },
          sql = { "sqlfluff" },
          yaml = { "yamlfmt" }
        }
      })
      local util = require("conform.util")
      util.add_formatter_args(
        require("conform.formatters.shfmt"),
        { "-i", "4", "-bn", "-sr", "-p", "-ci" }
      )
      util.add_formatter_args(
        require("conform.formatters.yamlfmt"),
        { "-formatter", "retain_line_breaks_single=true" }
      )
      local wk = require("which-key")
      wk.register({
        d = {
          name = "lsp",
          F = {
            "<cmd>lua require('conform').format({ timeout_ms=5000 })<cr>",
            "Format buffer"
          }
        }
      }, { prefix = "<leader>" })
    end
  },

  {
    "mfussenegger/nvim-lint",
    ft = {
      "css", "scss", "less",
      "dockerfile",
      "gitcommit",
      "markdown",
      "sh",
      "sql",
      "yaml"
    },
    config = function()
      require("lint").linters_by_ft = {
        css = { "stylelint" }, scss = { "stylelint" }, less = { "stylelint" },
        dockerfile = { "hadolint" },
        gitcommit = { "gitlint" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        yaml = { "actionlint", "yamllint" }
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
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    config = function()
      require("inc_rename").setup()
      local wk = require("which-key")
      wk.register({ ["<leader>dr"] = { "Rename identifier" } })
      vim.keymap.set("n", "<leader>dr", ":IncRename ")
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      action_keys = {
        close = "<esc>",
        cancel = {}
      }
    }
  }
}
