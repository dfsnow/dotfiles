return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        integrations = {
          which_key = true,
          gitsigns = true,
          flash = true,
          mason = true
        },
        custom_highlights = function(colors)
          return {
            NonText = { fg = colors.surface1 },
            CmpItemAbbr = { fg = colors.text },
            CmpItemAbbrMatch = { fg = colors.red },
            NormalFloat = { bg = colors.none },
            FlashBackdrop = { fg = colors.overlay0 },
            FlashLabel = { fg = colors.base, bg = colors.red },
            FzfLuaBorder = { fg = colors.blue },
            FzfLuaTitle = { fg = colors.overlay2 }
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
      sections = {
        lualine_c = { {
          "filename",
          path = 4
        } },
      },
      tabline = {
        lualine_a = { {
          "buffers",
          max_length = vim.o.columns,
          symbols = {
            modified = "[+]",
            alternate_file = ""
          }
        } }
      }
    }
  },

  {
    "kosayoda/nvim-lightbulb",
    ft = lsp_ft,
    opts = {
      sign = {
        text = "A",
      },
      autocmd = {
        enabled = true
      },
      action_kinds = { "quickfix", "refactor" },
    }
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    main = "ibl",
    priority = 1000,
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "space:⋅"
      require("ibl").setup({
        scope = {
          enabled = true
        }
      })
    end
  },

  {
    "tzachar/highlight-undo.nvim",
    keys = "u",
    opts = {
      duration = 700,
      undo = {
        hlgroup = "IncSearch",
      },
      redo = {
        hlgroup = "IncSearch",
      },
      keymaps = {
        { "n", "u", "undo", {} },
        { "n", "U", "redo", {} },
      }
    }
  },

  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        select = {
          enabled = false
        }
      })
    end
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  }
}
