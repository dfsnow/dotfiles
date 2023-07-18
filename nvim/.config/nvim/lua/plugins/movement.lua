return {
  {
    "elihunter173/dirbuf.nvim"
  },

  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
      vim.keymap.set("n", "<SPACE>", function()
        local current_window = vim.fn.win_getid()
        require('leap').leap({ target_windows = { current_window } })
      end)
    end
  },

  {
    "ggandor/flit.nvim",
    config = function()
      require('flit').setup()
    end
  }
}
