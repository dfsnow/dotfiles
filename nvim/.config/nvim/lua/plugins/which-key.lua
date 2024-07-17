return {
  {
    "folke/which-key.nvim",
    version = "*",
    opts = {
      preset = "modern",
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
      win = { border = "rounded" },
      modes = {
        x = false,
        o = false,
        t = false,
        s = false
      }
    }
  }
}
