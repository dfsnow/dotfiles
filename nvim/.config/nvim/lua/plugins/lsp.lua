return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    version = "*",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
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
        "basedpyright",
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
        "gitlint",
        "hadolint",
        "htmlhint",
        "mypy",
        "shellcheck",
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
    version = "*",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    keys = {
      { "<leader>M", "<cmd>Mason<cr>", desc = "Open Mason" }
    },
    ft = require("config.filetypes").lsp_ft,
    opts = {
      diagnostics = {
        virtual_text = true,
        update_in_insert = false,
        severity_sort = true
      }
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          keymaps = {
            toggle_help = "?"
          }
        }
      })
      require("mason-lspconfig").setup({})
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            disableTaggedHints = true,
            typeCheckingMode = "standard"
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

      -- Prettify the LSP info and windows
      require("lspconfig.ui.windows").default_options.border = "rounded"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded"
        }
      )
    end
  },

  {
    "stevearc/conform.nvim",
    version = "*",
    ft = require("config.filetypes").format_ft,
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
      wk.add({
        {
          "<leader>dF",
          "<cmd>lua require('conform').format({ timeout_ms=5000 })<cr>",
          desc = "Format buffer"
        }
      })
    end
  },

  {
    "mfussenegger/nvim-lint",
    version = "*",
    ft = require("config.filetypes").lint_ft,
    config = function()
      require("lint").linters_by_ft = {
        css = { "stylelint" },
        html = { "htmlhint" },
        dockerfile = { "hadolint" },
        gitcommit = { "gitlint" },
        less = { "stylelint" },
        markdown = { "markdownlint" },
        python = { "mypy" },
        scss = { "stylelint" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        terraform = { "tflint" },
        yaml = { "yamllint" }
      }
      local wk = require("which-key")
      wk.add({
        {
          "<leader>dL",
          "<cmd>lua require('lint').try_lint()<cr>",
          desc = "Lint buffer"
        }
      })
    end
  },

  {
    "smjonas/inc-rename.nvim",
    version = "*",
    dependencies = {
      "stevearc/dressing.nvim",
      version = "*",
    },
    keys = { { "<leader>dr", ":IncRename ", desc = "Rename identifier" } },
    config = function()
      require("inc_rename").setup({ input_buffer_type = "dressing" })
    end
  },

  {
    "folke/trouble.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true
    }
  }
}
