return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        integrations = { which_key = true },
        custom_highlights = function(colors)
          return {
            NonText = { fg = colors.surface1 },
            TelescopeMatching = { fg = colors.red },
            TelescopePromptCounter = { fg = colors.mauve },
            CmpItemAbbr = { fg = colors.text },
            CmpItemAbbrMatch = { fg = colors.red },
            NormalFloat = { bg = colors.none },
            FlashBackdrop = { fg = colors.overlay0 },
            FlashLabel = { fg = colors.base, bg = colors.red },
          }
        end
      })
      vim.cmd([[colorscheme catppuccin]])
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "",
        theme = "catppuccin"
      },
      tabline = {
        lualine_a = {
          { "buffers", symbols = { modified = "[+]", alternate_file = "" } }
        }
      }
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { 
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true 
          }
        end

        vim.keymap.set("n", "<Space>",         api.node.open.edit,                    opts("Open"))
        vim.keymap.set("n", "<CR>",            api.node.open.edit,                    opts("Open"))
        vim.keymap.set("n", "<BS>",            api.node.navigate.parent_close,        opts("Close directory"))
        vim.keymap.set("n", "<leader><Space>", api.tree.change_root_to_node,          opts("Set as root"))
        vim.keymap.set("n", "-",               api.tree.change_root_to_parent,        opts("Up directory"))
        vim.keymap.set("n", "<leader>k",       api.node.show_info_popup,              opts("Info"))
        vim.keymap.set("n", ".",               api.node.run.cmd,                      opts("Run command"))
        vim.keymap.set("n", "a",               api.fs.create,                         opts("Create"))
        vim.keymap.set("n", "bd",              api.marks.bulk.delete,                 opts("Delete bookmarked"))
        vim.keymap.set("n", "bmv",             api.marks.bulk.move,                   opts("Move bookmarked"))
        vim.keymap.set("n", "c",               api.fs.copy.node,                      opts("Copy"))
        vim.keymap.set("n", "<leader>gn",      api.node.navigate.git.next,            opts("Next git"))
        vim.keymap.set("n", "<leader>gp",      api.node.navigate.git.prev,            opts("Prev git"))
        vim.keymap.set("n", "d",               api.fs.remove,                         opts("Delete"))
        vim.keymap.set("n", "D",               api.fs.trash,                          opts("Trash"))
        vim.keymap.set("n", "E",               api.tree.expand_all,                   opts("Expand all"))
        vim.keymap.set("n", "<leader>dn",      api.node.navigate.diagnostics.next,    opts("Next diagnostic"))
        vim.keymap.set("n", "<leader>dp",      api.node.navigate.diagnostics.prev,    opts("Prev diagnostic"))
        vim.keymap.set("n", "?",               api.tree.toggle_help,                  opts("Help"))
        vim.keymap.set("n", "J",               api.node.navigate.sibling.last,        opts("Last sibling"))
        vim.keymap.set("n", "K",               api.node.navigate.sibling.first,       opts("First sibling"))
        vim.keymap.set("n", "m",               api.marks.toggle,                      opts("Toggle bookmark"))
        vim.keymap.set("n", "o",               api.node.open.edit,                    opts("Open"))
        vim.keymap.set("n", "p",               api.fs.paste,                          opts("Paste"))
        vim.keymap.set("n", "q",               api.tree.close,                        opts("Close"))
        vim.keymap.set("n", "r",               api.fs.rename,                         opts("Rename"))
        vim.keymap.set("n", "R",               api.tree.reload,                       opts("Refresh"))
        vim.keymap.set("n", "W",               api.tree.collapse_all,                 opts("Collapse all"))
        vim.keymap.set("n", "x",               api.fs.cut,                            opts("Cut"))
        vim.keymap.set("n", "y",               api.fs.copy.filename,                  opts("Copy name"))
        vim.keymap.set("n", "Y",               api.fs.copy.relative_path,             opts("Copy relative Path"))

      end

      require("nvim-tree").setup({
        on_attach = on_attach
      })

    end
  },

  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    config = function()
      require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
      vim.fn.sign_define("LightBulbSign", {
        text = "A",
        texthl = "A",
        linehl = "A",
        numhl = "A"
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "space:⋅"
      require("indent_blankline").setup({
        show_current_context = true,
        show_end_of_line = true,
        space_char_blankline = " ",
      })
    end
  },

  {
    "tzachar/highlight-undo.nvim",
    opts = {
      hlgroup = "IncSearch",
      duration = 700,
      keymaps = {
        {"n", "u", "undo", {}},
        {"n", "U", "redo", {}},
      }
    }
  },

  { 
    "nvim-tree/nvim-web-devicons",
    lazy = true
  }
}
