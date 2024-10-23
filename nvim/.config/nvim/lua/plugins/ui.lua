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
        custom_highlights = function(c)
          return {
            NonText = { fg = c.surface1 },
            CmpItemAbbr = { fg = c.text },
            CmpItemAbbrMatch = { fg = c.red },
            NormalFloat = { bg = c.none },
            FlashBackdrop = { fg = c.overlay0 },
            FlashLabel = { fg = c.base, bg = c.red },
            FzfLuaBorder = { fg = c.blue },
            FzfLuaTitle = { fg = c.overlay2 },
            HighlightUndo = { link = "IncSearch" },
          }
        end
      })
      vim.cmd("colorscheme catppuccin")
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    version = "*",
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
        lualine_b = { require("config.helpers").fzf_cwd },
        lualine_c = {
          { "filename", path = 4 },
          {
            "branch",
            fmt = function(str)
              if str ~= "" then
                return "(" .. str .. ")"
              else
                return str
              end
            end
          },
          "diff",
          "diagnostics"
        },
        lualine_x = {
          {
            'searchcount',
            maxcount = 9999,
            timeout = 500,
          },
          "encoding", "fileformat", "filetype"
        }
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            max_length = function() return vim.o.columns end,
            symbols = {
              modified = "[+]",
              alternate_file = ""
            },
            filetype_names = {
              lazy = "lazy",
              mason = "mason",
              oil = "oil",
              fzf = "fzf",
              trouble = "trouble"
            }
          }
        }
      }
    }
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "*",
    lazy = false,
    main = "ibl",
    priority = 1000,
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "eol:↴"
      vim.opt.listchars:append "space:⋅"
      require("ibl").setup({
        scope = {
          enabled = true,
          show_end = false
        }
      })
    end
  },

  {
    "folke/trouble.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
      keys = {
        ["<esc>"] = "close",
        ["<tab>"] = "next",
        ["<s-tab>"] = "prev"
      }
    }
  },

  {
    "tzachar/highlight-undo.nvim",
    version = "*",
    keys = { "u", "U", "p", "P" },
    opts = { duration = 700 }
  },

  {
    "nvim-tree/nvim-web-devicons",
    version = "*",
  }
}
