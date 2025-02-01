return {
  {
    "lewis6991/gitsigns.nvim",
    version = "*",
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "-" },
        topdelete    = { text = "‾" },
        changedelete = { text = "_" },
        untracked    = { text = "┆" },
      },
      preview_config = { border = "single" }
    }
  }
}
