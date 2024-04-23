return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    branch = "0.1.x",
    cmd = "Telescope",

    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end
      }
    },

    config = function()
      actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git/.*", "renv/.*" },
          layout_strategy = "flex",
          layout_config = {
            horizontal = { preview_cutoff = 0, width = 0.90, height = 0.85 },
            vertical = { preview_cutoff = 0, width = 0.90 },
          },
          hidden = true,
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<Esc>"] = actions.close,
              ["<C-j>"] = { actions.move_selection_next, type = "action" },
              ["<C-k>"] = { actions.move_selection_previous, type = "action" }
            }
          },
        },
        pickers = {
          find_files = {
            hidden = true
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_cursor()
          }
        }
      })
    end
  }
}
