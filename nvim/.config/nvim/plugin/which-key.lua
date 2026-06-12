vim.pack.add({
  gh("folke/which-key.nvim"),
})

require("which-key").setup({
  preset = "modern",
  icons = { mappings = false },
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
  win = { no_overlap = false, border = "single" },
  triggers = { "<auto>", mode = "nc" },
  -- Ignore diffview bindings
  filter = function(mapping)
    return mapping.desc ~= "diffview_ignore"
  end
})
