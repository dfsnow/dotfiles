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
          require("CopilotChat").toggle()
        end,
        mode = { "n", "v" },
        desc = "Toggle Copilot chat"
      },
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle()
        end,
        mode = { "n", "v" },
        desc = "Toggle chat"
      },
      {
        "<leader>?",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        mode = { "n", "v" },
        desc = "Pick Copilot prompt",
        silent = true
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        mode = { "n", "v" },
        desc = "Pick prompt",
        silent = true
      },
      {
        "<leader>am",
        function()
          require("CopilotChat").select_model()
        end,
        mode = { "n", "v" },
        desc = "Pick model",
        silent = true
      }
    },
    config = function()
      local chat = require("CopilotChat")
      chat.setup({
        model = "gpt-4o",
        log_level = "warn",
        show_folds = false,
        show_help = false,
        auto_follow_cursor = false,
        auto_insert_mode = false,
        chat_autocomplete = false,
        highlight_selection = false,
        window = {
          layout = "float",
          border = "rounded"
        },
        mappings = {
          close = {
            normal = "<esc>"
          },
          reset = {
            normal = "<leader>ax",
            insert = ""
          },
          submit_prompt = {
            normal = "<leader><cr>",
            insert = "<leader><cr>"
          },
          accept_diff = {
            normal = "<leader>ac",
            insert = ""
          },
          yank_diff = {
            normal = "<leader>ay",
            insert = ""
          },
          show_diff = {
            normal = "<leader>ad",
            insert = ""
          }
        }
      })
      -- Conditionally add mappings only for Copilot buffer
      local wk = require("which-key")
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          wk.add({
            { "<esc>",        desc = "Exit chat" },
            { "<leader><cr>", desc = "Submit prompt" },
            { "<leader>ax",   desc = "Reset chat" },
            { "<leader>ay",   desc = "Yank diff" },
            { "<leader>ac",   desc = "Accept diff" },
            { "<leader>ad",   desc = "Show diff" },
            { "<leader>as",   "<cmd>CopilotChatStop<cr>",  desc = "Stop response" },
            { "<leader>ar",   "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
            buffer = true,
            mode = { "n", "v" },
          })
        end
      })
    end
  }
}
