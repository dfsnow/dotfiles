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
      }
    },
    config = function()
      local helpers = require("config.helpers")
      local screen_width = vim.o.columns
      local w, h, c, r = helpers.get_float_size(float_width_pct, float_height_pct)
      if screen_width > 100 then
        w = math.min(math.floor(w * 0.6), 108)
        c = math.floor((screen_width) / 2) + math.floor(c / 2)
      end
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
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
              border = "rounded",
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
