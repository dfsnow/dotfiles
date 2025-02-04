return {
  {
    "saghen/blink.cmp",
    version = "*",
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
        "zbirenbaum/copilot.lua",
        version = "*",
        {
          "saghen/blink.compat",
          opts = {
            impersonate_nvim_cmp = true,
            enable_events = true
          }
        }
      },
      { "rafamadriz/friendly-snippets" }
    },
    opts = {
      keymap = {
        ["<tab>"] = { "select_next" },
        ["<s-tab>"] = { "select_prev" },
        ["<cr>"] = { "accept" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true },
        ghost_text = { enabled = true }
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {

        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink.compat.source",
            enabled = true,
            opts = {},
          },
        },
      },
    },
    opts_extend = { "sources.default" }
  }
}
