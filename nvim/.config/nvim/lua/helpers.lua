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

-- Get window size/position for most floating windows. If full is true,
-- the float is nearly the full width of the editor (for Diffview and lazygit)
function M.get_float_size(full)
  local columns = vim.o.columns
  local tabline = (vim.o.showtabline == 2
    or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)) and 1 or 0
  local statusline = vim.o.laststatus > 0 and 1 or 0
  local w = math.ceil(columns * M.float_width_pct)
  local h = vim.o.lines - tabline - statusline - vim.o.cmdheight - 2
  local c = math.floor((columns - w) / 2)
  local r = tabline

  if full then
    w = columns - 4
    c = 1
  elseif columns > 100 then
    w = math.min(math.floor(w * 0.6), 108)
    c = math.floor(columns / 2) + math.floor(c / 2)
  end

  return w, h, c, r
end

-- Get a window config for nvim_open_win or nvim_win_set_config that uses
-- the size from get_float_size. Keys in extra are added to the config
function M.float_win_config(full, extra)
  local w, h, c, r = M.get_float_size(full)
  return vim.tbl_extend("force",
    { relative = "editor", width = w, height = h, col = c, row = r }, extra or {})
end

-- Get toggleterm float_opts that use the size from get_float_size. Functions
-- are used so that the size is calculated again each time the float opens.
-- Keys in extra are added to the options
function M.term_float_opts(full, extra)
  return vim.tbl_extend("force", {
    width = function() return select(1, M.get_float_size(full)) end,
    height = function() return select(2, M.get_float_size(full)) end,
    col = function() return select(3, M.get_float_size(full)) end,
    row = function() return select(4, M.get_float_size(full)) end,
  }, extra or {})
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
