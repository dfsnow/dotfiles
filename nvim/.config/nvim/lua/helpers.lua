local M = {}

-- Width of most floating windows, as a fraction of the editor width.
-- The height is always the area between the tabline and the statusline
M.float_width_pct = 0.88

-- Close all floating windows
function M.close_floating_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end

-- Search from CWD if not in a git dir
function M.cwd_or_git()
  local cwd = vim.uv.cwd()
  return vim.fs.root(cwd, ".git") or cwd
end

-- Helper used to display the cwd in the statusline via lualine
function M.fzf_cwd()
  local path = vim.uv.cwd() or ""
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
function M.get_float_size()
  local columns = vim.o.columns
  local tabline = (vim.o.showtabline == 2
    or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)) and 1 or 0
  local statusline = vim.o.laststatus > 0 and 1 or 0
  local w = math.ceil(columns * M.float_width_pct)
  local h = vim.o.lines - tabline - statusline - vim.o.cmdheight - 2
  local c = math.floor((columns - w) / 2)
  local r = tabline

  if columns > 100 then
    w = math.min(math.floor(w * 0.6), 108)
    c = math.floor(columns / 2) + math.floor(c / 2)
  end

  return w, h, c, r
end

-- Check if the buffer is absolutely huge then use it to toggle off
-- heavy features (LSP, treesitter, etc.)
function M.is_big_file(buf)
  local max_lines = 2000
  local max_filesize = 1024 * 1024 * 3
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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
