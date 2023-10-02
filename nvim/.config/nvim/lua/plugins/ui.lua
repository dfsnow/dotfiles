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

      -- Activate wrapping and zen mode by default for certain filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "txt", "rmd", "qmd", "lazy" },
        callback = function()
          vim.opt_local.list = false
          require("ibl").setup_buffer(0, { enabled = false })
          vim.b.zen_toggle_flag = true
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      })
    end
  },

  {
    "tzachar/highlight-undo.nvim",
    opts = {
      duration = 700,
      undo = {
        hlgroup = "IncSearch",
      },
      redo = {
        hlgroup = "IncSearch",
      },
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
