local M = {}

-- Close all floating windows
function M.close_floating_windows()
  local valid_relatives = { "editor", "win" }
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.tbl_contains(valid_relatives, vim.api.nvim_win_get_config(win).relative) then
      vim.api.nvim_win_close(win, false)
    end
  end
end

-- Search from CWD if not in a git dir
function M.cwd_or_git()
  if M.get_git_exit() == 0 then
    return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  else
    return vim.loop.cwd()
  end
end

-- Check if there are words before the cursor
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
function M.has_words_before()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  ---@diagnostic disable-next-line: deprecated
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- Helper used to display the cwd in the statusline via lualine
function M.fzf_cwd()
  local path = vim.loop.cwd()
  local fzf_lua = require("fzf-lua")
  path = fzf_lua.path.HOME_to_tilde(path)
  path = fzf_lua.path.shorten(path)
  return path
end

-- Helper to replicate Alt-C function inside vim
function M.fzf_dirs(opts)
  opts = opts or {}
  opts.fzf_cli_args = "--walker=dir --scheme=path"
  opts.prompt = "Dir> "
  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("cd " .. selected[1])
    end
  }
  require("fzf-lua").fzf_exec(os.getenv("FZF_ALT_C_COMMAND"), opts)
end

-- Get window size/position for most floating windows
function M.get_float_size(w_pct, h_pct)
  local w = math.ceil(vim.o.columns * w_pct)
  local h = math.ceil(vim.o.lines * h_pct) + 2
  local c = math.floor((vim.o.columns - w) / 2 - 1)
  local r = math.floor((vim.o.lines - h) / 2 - 1)
  return w, h, c, r
end

-- Helper function to check if in a git dir
function M.get_git_exit()
  return os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
end

-- Check if the buffer is absolutely huge then use it to toggle off
-- heavy features (LSP, treesitter, etc.)
function M.is_big_file(_, buf)
  local max_lines = 2000
  local max_filesize = 1024 * 1024 * 3
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and (vim.api.nvim_buf_line_count(buf) > max_lines
        or stats.size > max_filesize) then
    return true
  end
end

-- Send the selected treesitter node to a tmux REPL using vim-slime. Sends the
-- current node if not in a node. Node selection only works for Python
function M.smart_send()
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
    feed_string = "<Plug>SlimeRegionSendgv<esc>"
  else
    vim.cmd('normal! V')
    feed_string = "<Plug>SlimeRegionSend<esc>j0"
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feed_string, true, true, true), "n", true)
end

-- Toggle autocompletion
vim.g.cmp_toggle_flag = true
function M.toggle_cmp()
  local cmp = require("cmp")
  local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
  if next_cmp_toggle_flag then
    print("Completion on")
  else
    print("Completion off")
  end
  if next_cmp_toggle_flag then
    cmp.setup({
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  end
end

-- Toggle diagnostics
function M.toggle_buffer_diagnostics()
  local diag_toggle_flag = vim.diagnostic.is_enabled({ ns_id = nil, bufnr = 0 })
  if diag_toggle_flag then
    print("Diagnostics off")
    vim.diagnostic.enable(false, { ns_id = nil, bufnr = 0 })
  else
    print("Diagnostics on")
    vim.diagnostic.enable(true, { ns_id = nil, bufnr = 0 })
  end
end

-- Toggle eol, space characters, scope markers, and autocomplete
vim.b.zen_toggle_flag = false
function M.toggle_zen_mode()
  local next_zen_toggle_flag = not vim.b.zen_toggle_flag
  local next_fold_flag = false
  if next_zen_toggle_flag then
    print("Zen mode on")
    vim.opt_local.list = false
    require("ibl").setup_buffer(0, { enabled = false })

    local original_fold_flag = vim.opt_local.foldenable:get()
    if original_fold_flag then
      next_fold_flag = original_fold_flag
      vim.opt_local.foldenable = false
    end
    require("cmp").setup({
      completion = {
        autocomplete = false
      }
    })
  else
    print("Zen mode off")
    vim.opt_local.list = true
    require("ibl").setup_buffer(0, { enabled = true })
    if next_fold_flag then
      vim.opt_local.foldenable = true
    end
    require("cmp").setup({
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
      }
    })
  end
  vim.b.zen_toggle_flag = next_zen_toggle_flag
end

return M
