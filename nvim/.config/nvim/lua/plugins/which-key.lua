return {
  {
    "folke/which-key.nvim",
    version = "*",
    opts = {
      preset = "modern",
      sort = { "manual", "local", "order" },
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
      win = { no_overlap = false, border = "rounded" },
      triggers = { "<auto>", mode = "nic" }
    }
  }
}
