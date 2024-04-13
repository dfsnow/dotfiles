return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }
    },
    opts = {
      show_help = false,
      context = "buffer",
      show_folds = false,
      window = {
        layout = "float",
        width = 0.88,
        height = 0.75,
        border = "rounded"
      },
      mappings = {
        close = {
          normal = "<Esc>"
        }
      }
    },
    keys = {
      {
        "?",
        function()
          require("CopilotChat").toggle({
              selection = require("CopilotChat.select").visual,
          })
        end,
        mode = {"n", "v"},
        desc = "Toggle Copilot Chat",
      },
      {
        "<leader>?",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        mode = {"n", "v"},
        desc = "Open Copilot Chat prompts",
      }
    }
  }
}
