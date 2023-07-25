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
            CmpItemAbbr = { fg = colors.text },
            CmpItemAbbrMatch = { fg = colors.red },
            NormalFloat = { bg = colors.none },
            FlashBackdrop = { fg = colors.overlay0 },
            FlashLabel = { fg = colors.base, bg = colors.red },
            -- FlashMatch = { fg = colors.base, bg = "#00dfff" },
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
    "kosayoda/nvim-lightbulb",
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
