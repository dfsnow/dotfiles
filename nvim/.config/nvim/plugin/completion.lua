if vim.g.vscode then return end

vim.pack.add({
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<s-tab>"] = { "snippet_backward", "select_prev", "fallback" },
    ["K"] = { "scroll_documentation_up", "fallback" },
    ["J"] = { "scroll_documentation_down", "fallback" }
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0
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
  }
})
