return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "giuxtaposition/blink-cmp-copilot" },
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
        ["<tab>"] = { "select_next" },
        ["<s-tab>"] = { "select_prev" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true },
        ghost_text = { enabled = false }
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          }
        }
      }
    },
    opts_extend = { "sources.default" }
  }
}
