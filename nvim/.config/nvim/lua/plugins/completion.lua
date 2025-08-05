return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
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
      cmdline = {
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = true } },
        }
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      }
    },
    opts_extend = { "sources.default" }
  }
}
