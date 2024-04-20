return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false }
        }
      },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end
      },
      {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	build = "make install_jsregexp",
        dependencies = { 
          "rafamadriz/friendly-snippets",
          "saadparwaiz1/cmp_luasnip"
        }
      },
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc"
    },

    config = function()
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end

      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

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
          end
        end,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping.scroll_docs(-4),
          ["<C-n>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
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
          { name = "path",       max_item_count = 4},
          { name = "nvim_lsp",   max_item_count = 9, keyword_length = 1 },
          { name = "buffer",     max_item_count = 9, keyword_length = 2 },
          { name = "copilot",    max_item_count = 4 },
          { name = "luasnip",    max_item_count = 4 },
          { name = "nvim_lsp_signature_help" },
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
      function toggleAutoCmp()
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
