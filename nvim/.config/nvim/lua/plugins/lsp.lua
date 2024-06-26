return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      run_on_start = false,
      ensure_installed = {
        -- Language servers
        "bashls",
        "cssls",
        "dockerls",
        "docker_compose_language_service",
        "html",
        "lua_ls",
        "pyright",
        "terraform-ls",
        -- "r_language_server", Not installed by default, too heavy
        "ruff",
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
        "htmlhint",
        "shellcheck",
        "sqlfluff",
        "stylelint",
        "tflint",
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
    keys = {
      { "<leader>M", "<cmd>Mason<cr>", desc = "Open Mason" }
    },
    ft = lsp_ft,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          width = 0.88,
          height = 0.75
        }
      })
      require("mason-lspconfig").setup({})
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({
        capabilities = capabilities,
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
        capabilities = capabilities,
        filetypes = { "r", "rmd", "quarto" }
      })
      lspconfig.ruff.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })

      -- Prettify the LSP info window
      require("lspconfig.ui.windows").default_options.border = "rounded"
    end
  },

  {
    "stevearc/conform.nvim",
    ft = format_ft,
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          bash = { "shfmt" },
          json = { "jq" },
          sh = { "shfmt" },
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
    ft = lint_ft,
    config = function()
      require("lint").linters_by_ft = {
        css = { "stylelint" },
        html = { "htmlhint" },
        dockerfile = { "hadolint" },
        gitcommit = { "gitlint" },
        less = { "stylelint" },
        markdown = { "markdownlint" },
        scss = { "stylelint" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        terraform = { "tflint" },
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
    end
  },

  {
    "smjonas/inc-rename.nvim",
    keys = { { "<leader>dr", ":IncRename ", desc = "Rename identifier" } },
    config = function()
      require("inc_rename").setup({ input_buffer_type = "dressing" })
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true
    }
  }
}
