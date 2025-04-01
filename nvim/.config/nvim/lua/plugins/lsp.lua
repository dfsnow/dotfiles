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
        "eslint-lsp",
        "harper-ls",
        "html",
        "lua_ls",
        "pyright",
        "terraform-ls",
        -- "r_language_server", Not installed by default, too heavy
        "ruff",
        "rust_analyzer",
        "typescript-language-server",
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
      },
      servers = {
        bashls = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
        eslint = {},
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/dotfiles/spell/en.utf-8.add",
              linters = {
                spell_check = false,
                avoid_curses = false
              },
              markdown = {
                ignore_link_title = true
              }
            }
          }
        },
        html = {},
        lua_ls = {},
        pyright = {
          pyright = {
            disableOrganizeImports = true,
            disableTaggedHints = true
          },
          python = {
            analysis = {
              ignore = { "*" },         -- Using ruff
              typeCheckingMode = "standard",
              diagnosticSeverityOverrides = {
                reportUndefinedVariable = "none"
              }
            }
          }
        },
        r_language_server = {
          filetypes = { "r", "rmd", "quarto" }
        },
        ruff = {},
        rust_analyzer = {},
        terraformls = {},
        ts_ls = {},
        yamlls = {}
      }
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      require("mason").setup({
        ui = {
          border = "single",
          backdrop = 100,
          keymaps = {
            toggle_help = "?"
          }
        }
      })
      require("mason-lspconfig").setup({})

      -- blink.cmp language server setup
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- Prettify the LSP info and windows
      require("lspconfig.ui.windows").default_options.border = "single"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "single" }
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
        { "-i", "4", "-bn", "-sr", "-ci" }
      )
      util.add_formatter_args(
        require("conform.formatters.yamlfmt"),
        {
          "-formatter", "retain_line_breaks=true",
          "-formatter", "pad_line_comments=2"
        }
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
  }
}
