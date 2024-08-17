return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "*",
    cmd = { "CopilotChatToggle", "CopilotChatPrompt" },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }
    },
    keys = {
      {
        "?",
        function()
          require("CopilotChat").toggle({
            selection = require("CopilotChat.select").visual,
          })
        end,
        mode = { "n", "v" },
        desc = "Toggle Copilot Chat",
      }
    },
    config = function()
      local chat = require("CopilotChat")
      chat.setup({
        show_folds = false,
        show_help = false,
        auto_follow_cursor = false,
        auto_insert_mode = false,
        context = "buffer",
        window = {
          layout = "float",
          border = "rounded"
        },
        mappings = {
          close = {
            normal = "<esc>"
          },
          reset = {
            normal = "<leader><esc>",
            insert = "<leader><esc>"
          },
          submit_prompt = {
            normal = "<leader><cr>",
            insert = "<leader><cr>"
          },
          accept_diff = {
            normal = "<leader>p",
            insert = "<leader>p"
          },
          yank_diff = {
            normal = "<leader>y"
          }
        }
      })
      require("CopilotChat.integrations.cmp").setup()
    end
  }
}
