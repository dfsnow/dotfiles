return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        version = "*",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false }
        }
      },
      {
        "zbirenbaum/copilot-cmp",
        version = "*",
        config = function()
          require("copilot_cmp").setup()
        end
      },
      {
        "garymjr/nvim-snippets",
        version = "*",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        opts = {
          friendly_snippets = true
        }
      },
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-cmdline"
    },

    config = function()
      local cmp = require("cmp")
      local helpers = require("config.helpers")
      local lspkind = require("lspkind")

      -- Setup autopairs completion/integration. See autopairs README
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )

      -- cmp command line completion. See cmp README
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        enabled = function()
          -- Only trigger if there are words before the cursor
          -- Don't trigger completion in prompts, comments, or snippets
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          elseif vim.bo.buftype == "prompt" then
            return false
          else
            return helpers.has_words_before()
                and not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
                and not vim.snippet.active({ direction = 1 })
          end
        end,
        snippet = {
          expand = function(arg)
            vim.snippet.expand(arg.body)
          end
        },
        mapping = {
          -- Use <Tab> and <S-Tab> to navigate through popup menu. See cmp wiki
          ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function() vim.snippet.jump(1) end)
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif helpers.has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["K"] = cmp.mapping.scroll_docs(-4),
          ["J"] = cmp.mapping.scroll_docs(4),
          ["<ESC>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.abort()
              elseif vim.snippet.active() then
                vim.snippet.stop()
                fallback()
              else
                fallback()
              end
            end
          }),
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = false
                })
              else
                fallback()
              end
            end
          })
        },
        sources = {
          { name = "path",                    max_item_count = 3 },
          { name = "snippets",                max_item_count = 2 },
          { name = "nvim_lsp",                max_item_count = 4 },
          { name = "nvim_lsp_signature_help", max_item_count = 3 },
          { name = "buffer",                  max_item_count = 3 },
          { name = "copilot",                 max_item_count = 3 },
          { name = "calc" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Copilot = "" }
          })
        }
      })
    end
  }
}
