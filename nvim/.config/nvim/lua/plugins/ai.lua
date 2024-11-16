local system_prompt = string.format([[
You are an AI programming assistant.
Follow the user's requirements carefully & to the letter.
Do not repeat code from the user's active document if only a subset is asked about.
Keep your answers as short as possible and minimize prose except where useful.
Do not provide unnecessary information.
Output the code in a single code block.
This code block should not contain line numbers
(line numbers are not necessary for the code to be understood, they are in format number: at beginning of lines).
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which uses a buffer for individual files and multiple buffers for a workspace.
The user is working on a %s machine. Please respond with system specific commands if applicable.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.
Again, the output should never contain line numbers.
]],
  vim.loop.os_uname().sysname
)

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
        desc = "Toggle Copilot chat"
      },
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle({
            selection = require("CopilotChat.select").visual,
          })
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
        context = "buffer",
        system_prompt = system_prompt,
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
            { "<leader>as",   "<cmd>CopilotChatStop<cr>", desc = "Stop response" },
            buffer = true,
            mode = { "n", "v" },
          })
        end
      })
      require("CopilotChat.integrations.cmp").setup()
    end
  }
}
