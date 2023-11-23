return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    opts = {
      default_file_explorer = true,
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
      float = {
        override = function(conf)
          local w = math.floor(vim.o.columns * 0.88)
          local h = math.floor(vim.o.lines * 0.75)
          local r = math.floor((vim.o.lines - h) / 2 - 1)
          local c = math.floor((vim.o.columns - w) / 2 - 1)
	  conf["width"] = w
	  conf["height"] = h
          conf["row"] = r
          conf["col"] = c
	  return(conf)
        end
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
  },

  {
    "chrisgrieser/nvim-spider",
    config = function()
      vim.keymap.set(
        { "n", "o", "x" },
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        { desc = "Next word (start)" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        { desc = "Next word (end)" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        { desc = "Previous word (start)" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        { desc = "Previous word (end)" }
      )
    end
  }
}
