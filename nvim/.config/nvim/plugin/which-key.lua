vim.pack.add({
  gh("folke/which-key.nvim"),
})

require("which-key").setup({
  preset = "modern",
  icons = { mappings = false },
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 10,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      nav = false,
    },
  },
  -- The "modern" preset uses a rounded border, so set it here
  win = { no_overlap = false, border = "single" },
  triggers = { "<auto>", mode = "nc" },
  -- Ignore diffview bindings
  filter = function(mapping)
    return mapping.desc ~= "diffview_ignore"
  end
})
