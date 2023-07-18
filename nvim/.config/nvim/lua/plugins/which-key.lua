return {
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.register(mappings, opts)
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 10,
          },
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = true,
            nav = false,
            z = true,
            g = true,
          },
        },
        window = { border = "rounded" },
        key_labels = {
          ["<space>"]    = "SPC",
          ["<cr>"]       = "RET",
          ["<CR>"]       = "RET",
          ["<Tab>"]      = "TAB",
          ["<S-Tab>"]    = "S-TAB",
          ["<leader>"]   = "LDR",
          ["<c-w>"]      = "C-w",
          ["<C-R>"]      = "C-r",
          ["<C-T>"]      = "C-f",
          ["<C-A>"]      = "C-a",
          ["<C-X>"]      = "C-x",
        },
      })
      require("config/mappings")
    end
  }
}
