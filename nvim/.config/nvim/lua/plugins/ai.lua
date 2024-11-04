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
        desc = "Toggle Copilot Chat",
      },
      {
        "<leader>?",
        function()
          require("CopilotChat").select_model()
        end,
        mode = { "n", "v" },
        desc = "Pick Copilot model",
        silent = true
      }
    },
    config = function()
      local chat = require("CopilotChat")
      chat.setup({
        model = "claude-3.5-sonnet",
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
