return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "*",
    branch = "main",
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
        mode = { "n", "x" },
        desc = "Toggle Copilot chat"
      },
      {
        "<leader>aa",
        function()
          require("CopilotChat").select_agent()
        end,
        mode = { "n", "x" },
        desc = "Select agent"
      },
      {
        "<leader>?",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        mode = { "n", "x" },
        desc = "Pick Copilot prompt",
        silent = true
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        mode = { "n", "x" },
        desc = "Pick prompt",
        silent = true
      },
      {
        "<leader>am",
        function()
          require("CopilotChat").select_model()
        end,
        mode = { "n", "x" },
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
        highlight_selection = true,
        window = {
          layout = "float",
          border = "rounded"
        },
        mappings = {
          close = { normal = "<esc>" },
          reset = { normal = "<leader>ax", insert = "" },
          submit_prompt = { normal = "<leader><cr>", insert = "<leader><cr>" },
          accept_diff = { normal = "<leader>ay", insert = "" },
          yank_diff = { normal = "<leader>aY", insert = "" },
          show_diff = { normal = "<leader>ad", insert = "" },
          show_context = { normal = "<leader>ac", insert = "" },
          show_help = { normal = "<leader>ah", insert = "" },
          show_info = { normal = "<leader>ai", insert = "" },
          toggle_sticky = { normal = "" },
          jump_to_diff = { normal = "" },
          quickfix_diffs = { normal = "" },
        }
      })
      -- Conditionally add mappings only for Copilot buffer
      local wk = require("which-key")
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          wk.add({
            { "<esc>",        desc = "Exit chat" },
            { "<leader>ax",   desc = "Reset chat" },
            { "<leader><cr>", desc = "Submit prompt" },
            { "<leader>ay",   desc = "Accept diff" },
            { "<leader>aY",   desc = "Yank diff" },
            { "<leader>ad",   desc = "Show diff" },
            { "<leader>ac",   desc = "Show context" },
            { "<leader>ah",   desc = "Show help" },
            { "<leader>ai",   desc = "Show info" },
            { "<leader>as",   "<cmd>CopilotChatStop<cr>",  desc = "Stop response" },
            { "<leader>ar",   "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
            buffer = true,
            mode = { "n", "x" },
          })
        end
      })
    end
  }
}

