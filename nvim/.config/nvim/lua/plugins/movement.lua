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
      view_options = { show_hidden = true, },
      buf_options = { bufhidden = "unload" },
      win_options = { colorcolumn = "0" },
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
      search = {
        exclude = {
          "blink-cmp-menu",
          "blink-cmp-documentation",
          "blink-cmp-signature"
        }
      },
      modes = { char = { enabled = true } }
    },
    keys = {
      -- Mappings for flash are here instead of mappings.lua because
      -- they're used to lazy load flash
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
        -- Fix for not escaping in f/F mode:
	-- https://github.com/folke/flash.nvim/issues/401#issuecomment-2676690290
        "<esc>",
        mode = { "n", "x", "o" },
        function()
          local char = require("flash.plugins.char")
          if char.state then
            char.state:hide()
          end
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
        end,
        desc = "Cancel Flash Char"
      }
    }
  }
}
