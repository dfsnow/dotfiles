return {
  {
    "olimorris/codecompanion.nvim",
    version = "*",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "?",
        function()
          require("codecompanion").toggle()
        end,
        mode = { "n" },
        desc = "Toggle chat"
      },
      {
        "?",
        function()
          require("codecompanion").add()
        end,
        mode = { "x" },
        desc = "Send to chat"
      },
      {
        "<leader>?",
        function()
          require("codecompanion").actions()
        end,
        mode = { "n", "x" },
        desc = "Open chat actions"
      }
    },
    config = function()
      local helpers = require("config.helpers")
      local w, h, c, r = helpers.get_float_size(
        float_width_pct,
        float_height_pct,
        vim.o.columns
      )
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["help"] = {
                opts = {
                  provider = "fzf_lua",
                }
              }
            },
            keymaps = {
              send = { modes = { n = "<leader><cr>", i = "<leader><cr>" } }
            }
          },
          inline = {
            adapter = "copilot",
          },
        },
        display = {
          chat = {
            intro_message = "Press ? for help",
            window = {
              layout = "float",
              relative = "editor",
              border = "single",
              width = w,
              height = h,
              row = r,
              col = c,
              opts = {
                colorcolumn = "0",
                number = false
              }
            }
          }
        }
      })
    end
  }
}
