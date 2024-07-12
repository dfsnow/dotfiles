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
    "windwp/nvim-autopairs",
    version = "*",
    event = "InsertEnter",
    config = true
  }
}
