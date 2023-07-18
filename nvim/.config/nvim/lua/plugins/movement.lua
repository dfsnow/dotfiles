return {
  {
    "elihunter173/dirbuf.nvim"
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<space>",
      	mode = { "n", "x", "o" },
	function() require("flash").jump() end,
	desc = "Flash" 
      }
    }
  }
}
