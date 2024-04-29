return {
  "tpope/vim-sleuth",
  "tpope/vim-repeat",

  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      vim.keymap.set("n", "<leader>c", "<Plug>(comment_toggle_linewise_current)")
      vim.keymap.set("x", "<leader>c", "<Plug>(comment_toggle_linewise_visual)")
    end
  }
}
