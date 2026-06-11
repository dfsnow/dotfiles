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

-- Helper used to display the cwd in the statusline via lualine
function M.fzf_cwd()
  local path = vim.loop.cwd() or ""
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
  require("fzf-lua").fzf_exec(os.getenv("FZF_ALT_C_COMMAND") or "", opts)
end

-- Get window size/position for most floating windows
function M.get_float_size(w_pct, h_pct, screen_width)
  local w = math.ceil(vim.o.columns * w_pct)
  local h = math.ceil(vim.o.lines * h_pct) + 2
  local c = math.floor((vim.o.columns - w) / 2)
  local r = math.floor((vim.o.lines - h) / 2)

  if screen_width and screen_width > 100 then
    w = math.min(math.floor(w * 0.6), 108)
    c = math.floor(screen_width / 2) + math.floor(c / 2)
  end

  return w, h, c, r
end

-- Helper function to check if in a git dir
function M.get_git_exit()
  return os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
end

-- Check if the buffer is absolutely huge then use it to toggle off
-- heavy features (LSP, treesitter, etc.)
function M.is_big_file(buf)
  local max_lines = 2000
  local max_filesize = 1024 * 1024 * 3
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and (vim.api.nvim_buf_line_count(buf) > max_lines
        or stats.size > max_filesize) then
    return true
  end
end

-- Toggle LSP diagnostics for the current buffer
function M.toggle_buffer_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

return M
