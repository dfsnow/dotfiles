return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
      {
        "zbirenbaum/copilot.lua",
        version = "*",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false }
        }
      }
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            else
              return cmp.select_next()
            end
          end,
          "fallback"
        },
        ["<s-tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            else
              return cmp.select_prev()
            end
          end,
          "fallback"
        },
        ["K"] = { "scroll_documentation_up", "fallback" },
        ["J"] = { "scroll_documentation_down", "fallback" }
      },
      completion = {
        menu = { border = "single" },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = { border = "single" }
        },
        list = { selection = { preselect = false, auto_insert = false } },
        trigger = { show_in_snippet = false },
        ghost_text = { enabled = true }
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot", "markdown" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true
          },
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            fallbacks = { "lsp" }
          }
        }
      }
    },
    opts_extend = { "sources.default" }
  }
}
