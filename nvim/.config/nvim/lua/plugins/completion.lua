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
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        ---@diagnostic disable-next-line: deprecated
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )

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
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          elseif vim.bo.buftype == "prompt" then
            return false
          else
            return not context.in_treesitter_capture("comment")
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
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
          ["<C-p>"] = cmp.mapping.scroll_docs(-4),
          ["<C-n>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
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
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
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
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Copilot = "" }
          })
        }
      })

      -- Toggle autocompletion
      vim.g.cmp_toggle_flag = true
      function _G.toggleAutoCmp()
        local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
        if next_cmp_toggle_flag then
          print("Completion on")
        else
          print("Completion off")
        end
        if next_cmp_toggle_flag then
          cmp.setup({
            completion = {
              autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
            }
          })
          vim.g.cmp_toggle_flag = next_cmp_toggle_flag
        else
          cmp.setup({
            completion = {
              autocomplete = false
            }
          })
          vim.g.cmp_toggle_flag = next_cmp_toggle_flag
        end
      end
    end
  }
}
