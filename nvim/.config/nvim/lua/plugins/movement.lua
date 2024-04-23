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
        bufhidden = "hide"
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
        ["-"] = "actions.parent",
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
    "jpalardy/vim-slime",
    event = "VeryLazy",
    init = function()
      vim.g.slime_no_mappings = 1
    end,
    config = function()
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_preserve_curpos = 0
      vim.g.slime_paste_file = vim.fn.tempname()
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { 
        socket_name = "default",
        target_pane = "{bottom}" 
      }
      vim.cmd([[nmap <leader><cr> <Plug>SlimeLineSendj0]])
      vim.cmd([[vmap <leader><cr> <Plug>SlimeRegionSendgv<esc>]])
    end
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
