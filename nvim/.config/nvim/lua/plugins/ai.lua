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
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        mode = { "n", "v" },
        desc = "Open Copilot Chat prompts",
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

      -- Autocommand to always re-open the chat window in the same position
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function(opts)
          local prev_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
          if prev_line > 1
              and prev_line <= vim.api.nvim_buf_line_count(opts.buf)
          then
            vim.api.nvim_feedkeys([[g`"]], "n", true)
          end
        end
      })
    end
  }
}
