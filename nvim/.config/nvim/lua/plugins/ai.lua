return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = {"CopilotChatToggle", "CopilotChatPrompt"}, -- Add this line
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
        width = math.floor(vim.o.columns * 0.88),
        height = math.floor(vim.o.lines * 0.75),
        row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.75)) / 2 - 1),
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.88)) / 2 - 1),
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
        mode = { "n", "v" },
        desc = "Toggle Copilot Chat",
      },
      {
        "<leader>?",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        mode = { "n", "v" },
        desc = "Open Copilot Chat prompts",
      }
    }
  }
}
