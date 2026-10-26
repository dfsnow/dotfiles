if vim.g.vscode then return end

vim.pack.add({
  gh("dlyongemallo/diffview-plus.nvim"),
})

local wk = require("which-key")
local actions = require("diffview.actions")
local scroll_amount = 0.10

-- Sum the per-file line stats of the current view for the file panel winbar
function _G.DiffviewPanelStats()
  local view = require("diffview.lib").get_current_view()
  if not (view and view.files and view.files.iter) then return "" end

  local files, additions, deletions = 0, 0, 0
  for _, file in view.files:iter() do
    files = files + 1
    if file.stats and file.stats.additions then
      additions = additions + file.stats.additions
      deletions = deletions + file.stats.deletions
    end
  end

  return string.format(
    "  %d files %%#DiffviewFilePanelInsertions#+%d %%#DiffviewFilePanelDeletions#-%d",
    files, additions, deletions
  )
end

-- Diffview always runs in a nested nvim inside a float that is nearly the
-- full width of the editor. This is true when this nvim is the nested one
local in_float = vim.env.NVIM_DIFFVIEW_FLOAT == "1" and vim.env.NVIM ~= nil

-- Run some Lua in the parent nvim
local function call_parent(code, args)
  local chan = vim.fn.sockconnect("pipe", vim.env.NVIM, { rpc = true })
  vim.rpcrequest(chan, "nvim_exec_lua", code, args or {})
  vim.fn.chanclose(chan)
end

-- Open the file under the cursor in the parent nvim, behind the float
local function edit_in_parent()
  local file = require("diffview.lib").get_current_view():infer_cur_file()
  if file and file.absolute_path then
    call_parent("DiffviewFloatEdit(...)", { file.absolute_path })
  end
end

-- Like other floats, <esc> closes Diffview (and so the float)
local float_esc = in_float
    and { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close the diff view" } } or nil
local float_edit = in_float
    and { "n", "o", edit_in_parent, { desc = "Open the file in the parent nvim" } } or nil

if in_float then
  -- Do not let nvims started from this one think they are in the float
  vim.env.NVIM_DIFFVIEW_FLOAT = nil

  -- Hide lualine (the statusline and the buffer bar) and the ruler
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("diffview_float_lualine", { clear = true }),
    desc = "Hide lualine and the ruler in the Diffview float",
    callback = function()
      require("lualine").hide({ place = { "statusline", "tabline" } })
      vim.o.laststatus = 0
      vim.o.showtabline = 0
      vim.o.ruler = false
    end
  })

  -- Closing Diffview also quits this nvim and the float
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("diffview_float_quit", { clear = true }),
    pattern = "DiffviewViewClosed",
    desc = "Quit the nested nvim when Diffview closes",
    callback = function() vim.schedule(function() vim.cmd("qa!") end) end
  })

  vim.api.nvim_create_user_command("DiffviewToggle", function() call_parent("DiffviewFloatHide()") end, { nargs = "*" })
else
  -- The float and the Diffview command that it runs. Both are cleared when
  -- the nested nvim quits
  local float_term, float_cmd

  function _G.DiffviewFloatHide()
    vim.schedule(function()
      if float_term then float_term:close() end
    end)
  end

  -- Open a file in the window that was current before the float opened.
  -- The float stays open and keeps the focus
  function _G.DiffviewFloatEdit(path)
    vim.schedule(function()
      local win = require("toggleterm.ui").get_origin_window()
      if not (win and vim.api.nvim_win_is_valid(win)
            and vim.api.nvim_win_get_config(win).relative == "") then
        win = vim.fn.win_getid(vim.fn.winnr("#"))
      end
      vim.api.nvim_win_call(win, function() vim.cmd.edit(vim.fn.fnameescape(path)) end)
    end)
  end

  -- Run a Diffview command in the nested nvim. If the same command is
  -- already running, show its float again. The current file is opened in
  -- the nested nvim, so "%" and line ranges refer to the same file. It is
  -- opened with no swap file, so that it does not conflict with this nvim
  local function float_open(cmd)
    if float_term and cmd == float_cmd then
      if not float_term:is_open() then float_term:open() end
      return
    end
    if float_term then float_term:shutdown() end

    local shell_cmd = "nvim -n -c " .. vim.fn.shellescape(cmd)
    local file = vim.api.nvim_buf_get_name(0)
    if vim.bo.buftype == "" and vim.fn.filereadable(file) == 1 then
      shell_cmd = shell_cmd .. " -- " .. vim.fn.shellescape(file)
    end

    local helpers = require("helpers")
    float_cmd = cmd
    float_term = require("toggleterm.terminal").Terminal:new({
      cmd = shell_cmd,
      display_name = "diffview",
      direction = "float",
      close_on_exit = true,
      env = { NVIM_DIFFVIEW_FLOAT = "1" },
      float_opts = helpers.term_float_opts(true),
      on_open = function(term)
        vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr, nowait = true })
      end,
      on_exit = function(term)
        if term == float_term then float_term, float_cmd = nil, nil end
      end,
    })
    float_term:open()
  end

  -- Replace the commands that open a Diffview with ones that open it in
  -- the float
  for name, opts in pairs({
    DiffviewOpen = {},
    DiffviewFileHistory = { range = true },
    DiffviewDiffFiles = { nargs = "+" },
    DiffviewMergeFiles = { nargs = "+" },
    DiffviewDiffDirs = { nargs = "+" },
  }) do
    vim.api.nvim_create_user_command(name, function(ctx)
      local range = ctx.range > 0 and (ctx.line1 .. "," .. ctx.line2) or ""
      float_open(vim.trim(range .. name .. " " .. ctx.args))
    end, vim.tbl_extend("keep", opts, { nargs = "*", complete = require("diffview").completion }))
  end

  vim.api.nvim_create_user_command("DiffviewWorktreeOverview", function()
    float_open("DiffviewWorktreeOverview")
  end, { nargs = 0 })

  -- Show or hide the float if it is running, else open a new Diffview
  vim.api.nvim_create_user_command("DiffviewToggle", function(ctx)
    if not float_term then
      float_open(vim.trim("DiffviewOpen " .. ctx.args))
    else
      float_term:toggle()
    end
  end, { nargs = "*", complete = require("diffview").completion })

  vim.api.nvim_create_user_command("DiffviewClose", function()
    if float_term then float_term:shutdown() end
  end, { nargs = 0, bang = true })
end

require("diffview").setup({
  enhanced_diff_hl = true,
  file_panel = {
    show_branch_name = true,
    always_show_sections = true,
    win_config = {
      win_opts = { winbar = "%{%v:lua.DiffviewPanelStats()%}" },
    },
  },
  keymaps = {
    view = {
      { "n", "<leader>gn", "]c",                                { desc = "Jump to the next hunk" } },
      { "n", "<leader>gp", "[c",                                { desc = "Jump to the previous hunk" } },
      { "n", "K",          actions.scroll_view(-scroll_amount), { desc = "Scroll the view up" } },
      { "n", "J",          actions.scroll_view(scroll_amount),  { desc = "Scroll the view down" } },
      float_esc,
    },
    file_panel = {
      { "n", "K", actions.scroll_view(-scroll_amount), { desc = "Scroll the view up" } },
      { "n", "J", actions.scroll_view(scroll_amount),  { desc = "Scroll the view down" } },
      float_esc,
      float_edit,
    },
    file_history_panel = { float_esc, float_edit },
  }
})

wk.add({
  { "<leader>g",  group = "git" },
  { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "View full diff" }
})

wk.add({
  { "<leader>v",  group = "diff" },
  { "<leader>vv", "<cmd>DiffviewToggle<cr>",                desc = "Toggle diff view" },
  { "<leader>vt", "<cmd>DiffviewToggle<cr>",                desc = "Toggle diff view" },
  { "<leader>vo", "<cmd>DiffviewOpen<cr>",                  desc = "Open diff view" },
  { "<leader>vc", "<cmd>DiffviewClose<cr>",                 desc = "Close diff view" },
  { "<leader>vh", "<cmd>DiffviewFileHistory<cr>",           desc = "Repo history" },
  { "<leader>vf", "<cmd>DiffviewFileHistory %<cr>",         desc = "Current file history" },
  { "<leader>vR", "<cmd>DiffviewRefresh<cr>",               desc = "Refresh" },
  { "<leader>vl", "<cmd>.DiffviewFileHistory --follow<cr>", desc = "Line history" },
})

-- Review a PR against its base branch
vim.keymap.set("n", "<leader>vr", function()
  local function ref_exists(ref)
    vim.fn.systemlist({ "git", "rev-parse", "--verify", "--quiet", ref })
    return vim.v.shell_error == 0
  end

  local function first_existing(refs)
    for _, ref in ipairs(refs) do
      if ref_exists(ref) then return ref end
    end
  end

  local ref
  local pr = vim.fn.systemlist({ "gh", "pr", "view", "--json", "baseRefName", "--jq", ".baseRefName" })
  if vim.v.shell_error == 0 and pr[1] ~= nil and pr[1] ~= "" then
    -- Prefer the remote copy of the PR target, else the local branch
    ref = first_existing({ "origin/" .. pr[1], pr[1] })
  else
    -- No PR, so use the remote's default branch (e.g. "origin/main")
    local head = vim.fn.systemlist({ "git", "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" })
    if vim.v.shell_error == 0 and head[1] ~= nil and head[1] ~= "" then
      ref = head[1]
    else
      ref = first_existing({ "origin/main", "origin/master", "main", "master" })
    end
  end

  if not ref then
    vim.notify("No PR target or base branch found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("DiffviewOpen " .. ref .. "...HEAD --merge-base")
end, { desc = "Open PR diff" })

-- Treat any close gesture inside a Diffview tabpage as "close the whole
-- Diffview" so :q etc. never leave a half-torn-down split behind
local function in_diffview()
  return require("diffview.lib").get_current_view() ~= nil
end

vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("diffview_close_on_quit", { clear = true }),
  desc = "Close the entire Diffview on quit",
  callback = function()
    if in_diffview() then
      vim.schedule(function()
        if in_diffview() then vim.cmd("DiffviewClose") end
      end)
    end
  end
})

local function close_buffer()
  if in_diffview() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("Bclose")
  end
end
vim.keymap.set("n", "<leader>x", close_buffer, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bc", close_buffer, { desc = "Close" })
