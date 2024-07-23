return {
  {
    "stevearc/oil.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
          conf["width"] = float_width
          conf["height"] = float_height
          conf["row"] = float_row
          conf["col"] = float_col
          return (conf)
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
    version = "*",
    keys = "<leader><cr>",
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
      vim.cmd([[vmap <leader><cr> <Plug>SlimeRegionSendgvj0<esc>]])
    end
  },

  {
    "folke/flash.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
        }
      }
    },
    keys = {
      {
        "<space>",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash"
      },
      {
        "<leader><space>",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "<leader><s-space>",
        mode = { "n", "x", "o" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash search"
      }
    }
  }
}
