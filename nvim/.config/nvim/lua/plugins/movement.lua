return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon"
      },
      view_options = {
        show_hidden = true,
      },
      buf_options = {
        bufhidden = "wipe"
      },
      use_default_keymaps = false,
      keymaps = {
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<BS>"] = "actions.parent",
        ["<Esc>"] = "actions.close",
        ["<Tab>"] = "actions.close",
        ["<leader>-"] = "actions.select_vsplit",
        ["<leader>_"] = "actions.select_split",
        ["<leader><space>"] = "actions.preview",
        ["."] = "actions.open_cwd",
        ["<leader>."] = "actions.tcd",
      }
    }
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
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
