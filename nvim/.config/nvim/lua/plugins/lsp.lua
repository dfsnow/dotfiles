return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.r_language_server.setup{}
      lspconfig.pyright.setup{}
      lspconfig.html.setup{}
      lspconfig.cssls.setup{}
    end
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
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
    end
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rs",
    config = function()
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
