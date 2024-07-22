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
      local select = require("CopilotChat.select")

      local gitprompt =
          "Write commit message for the change in the standard " ..
          "imperative syntax. Make sure the title has maximum 50 " ..
          "characters and message is wrapped at 72 characters. " ..
          "Wrap the whole message in code block with language gitcommit."
      local writeprompt =
          "You are an excellent technical writer. Your writing balances " ..
          "conciseness and clarity. You writing style is suitable for " ..
          "READMEs, documentation, and technical blog posts, but your " ..
          "expertise goes beyond software topics. Use markdown formatting " ..
          "in your answers."

      local prompts = {
        -- Prompts for coding
        Explain = {
          prompt =
              "/COPILOT_EXPLAIN Write a text explanation for the active " ..
              "selection. Be as concise as possible."
        },
        Review = {
          prompt =
              "/COPILOT_REVIEW Review the selected code and provide " ..
              "suggestions for improvement. Be as concise as possible."
        },
        Fix = {
          prompt =
              "/COPILOT_GENERATE There is a problem in this code. " ..
              "Rewrite the code to show it with the bug fixed. Keep the " ..
              "spacing and indentation the same."
        },
        Optimize = {
          prompt =
              "/COPILOT_GENERATE Optimize the selected code to improve" ..
              "performance and readablilty."
        },
        Docs = {
          prompt =
              "/COPILOT_GENERATE Add a documentation comment for the " ..
              "selection. Do not add a comment if the code is self-explanatory."
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Generate tests for the selected code."
        },
        FixDiagnostic = {
          prompt = "Assist with the following diagnostic issue in file:",
          selection = select.diagnostics,
        },
        Commit = {
          prompt = gitprompt,
          selection = select.gitdiff
        },
        CommitStaged = {
          prompt = gitprompt,
          selection = function(source)
            return select.gitdiff(source, true)
          end
        },
        -- Prompts for writing
        Summarize = {
          system_prompt = writeprompt,
          prompt = "Summarize the selected text."
        },
        Spelling = {
          system_prompt = writeprompt,
          prompt = "Correct any grammar or spelling errors in the selected text."
        },
        Wording = {
          system_prompt = writeprompt,
          prompt = "Improve the grammar and wording of the selected text."
        },
        Concise = {
          system_prompt = writeprompt,
          prompt = "Rewrite the selected text to make it more concise."
        }
      }

      chat.setup({
        show_folds = false,
        show_help = false,
        auto_follow_cursor = false,
        auto_insert_mode = true,
        context = "buffer",
        prompts = prompts,
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
