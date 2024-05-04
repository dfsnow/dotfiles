return {
  {
    "stevearc/oil.nvim",
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
          local w = math.floor(vim.o.columns * 0.88)
          local h = math.floor(vim.o.lines * 0.75)
          local r = math.floor((vim.o.lines - h) / 2 - 1)
          local c = math.floor((vim.o.columns - w) / 2 - 1)
          conf["width"] = w
          conf["height"] = h
          conf["row"] = r
          conf["col"] = c
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
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local wk = require("which-key")
      local harpoon = require("harpoon")
      harpoon:setup()

      _G.fzf_harpoon = function(harpoon_files)
        local fzf_lua = require("fzf-lua")

        local file_paths = {}
        for _, item in pairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        opts = {}
        opts.prompt = "Harpoon> "
        opts.previewer = "builtin"
        opts.fn_transform = function(x)
          return fzf_lua.make_entry.file(x, {
            file_icons = true,
            color_icons = true,
            git_icons = true
          })
        end
        opts.preview = false
        opts.actions = {
          ["default"] = fzf_lua.actions.file_edit,
          ["ctrl-x"] = {
            function(selected)
              for _, f in ipairs(selected) do
                print(string.format("Removed %s from Harpoon", f:sub(11)))
                local _, idx = harpoon:list():get_by_value(f:sub(11))
                harpoon:list():remove_at(idx)
              end
            end,
            fzf_lua.actions.resume
          }
        }

        local cmd = string.format("ls %s", table.concat(file_paths, ' '))
        fzf_lua.fzf_exec(cmd, opts)
      end

      wk.register({
        h = {
          name = "harpoon",
          h = {
            "<cmd>lua _G.fzf_harpoon(require('harpoon'):list())<cr>",
            "Open Harpoon list"
          },
          a = {
            "<cmd>lua require('harpoon'):list():prepend()<cr>",
            "Add to Harpoon"
          },
          x = {
            "<cmd>lua require('harpoon'):list():remove()<cr>",
            "Remove from Harpoon"
          },
          c = {
            "<cmd>lua require('harpoon'):list():clear()<cr>",
            "Clear Harpoon list"
          }
        }
      }, { prefix = "<leader>" })

    end
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
