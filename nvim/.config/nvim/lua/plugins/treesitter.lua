return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    ft = treesitter_ft,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = treesitter_parsers,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
          disable = is_big_file
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        }
      })
    end
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "jpalardy/vim-slime"
    },
    ft = { "python" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer"
          }
        }
      })
      -- Adds a buffer local mapping to send the selected treesitter node
      -- to a tmux REPL using vim-slime. Sends the current node if not in a
      -- node. Only works for Python and R
      local smart_send = function()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local node = ts_utils.get_node_at_cursor()
        local feed_string = ''
        local patterns = {
          "function_definition",
          "class_definition",
          "while_statement",
          "for_statement",
          "if_statement",
          "with_statement",
          "try_statement"
        }

        local match_found = false
        for _, pattern in ipairs(patterns) do
          if string.match(node:sexpr(), pattern) then
            match_found = true
            break
          end
        end

        -- If in a matching node type that can be processed by textsubjects,
        -- then use textsubjects selection. Otherwise, send the current line
        if match_found then
          local txsub = require("nvim-treesitter.textsubjects")
          txsub.select("textsubjects-smart", true, vim.fn.getpos("."), vim.fn.getpos("."))
          vim.cmd('normal! v')
          feed_string = '<Plug>SlimeRegionSendgv<esc>'
        else
          vim.cmd('normal! V')
          feed_string = '<Plug>SlimeRegionSend<esc>j0'
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feed_string, true, true, true), 'n', true)
      end

      vim.keymap.set("n", "<leader><cr>", smart_send, { silent = true, noremap = true })
    end
  }
}
