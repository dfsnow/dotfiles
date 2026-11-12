if vim.g.vscode then return end

local helpers = require("helpers")
local wk = require("which-key")

-- hunk runs in a float that is nearly the full width of the editor. Its "e"
-- key opens $EDITOR, which is pointed at a script that opens the file in
-- this nvim, behind the float
local edit_script = vim.fn.stdpath("config") .. "/bin/hunk-edit.lua"

-- The float and the hunk command that it runs. Both are cleared when hunk
-- quits
local float_term, float_cmd

-- Open a file in the window that was current before the float opened.
-- The float stays open and keeps the focus
function _G.HunkFloatEdit(path, line)
  vim.schedule(function()
    local win = require("toggleterm.ui").get_origin_window()
    if not (win and vim.api.nvim_win_is_valid(win)
          and vim.api.nvim_win_get_config(win).relative == "") then
      win = vim.fn.win_getid(vim.fn.winnr("#"))
    end
    vim.api.nvim_win_call(win, function()
      vim.cmd.edit(vim.fn.fnameescape(path))
      pcall(vim.api.nvim_win_set_cursor, win, { line or 1, 0 })
    end)
  end)
end

-- Run a hunk command in the float. If the same command is already running,
-- show its float again
local function float_open(args)
  local cmd = "hunk " .. args
  if float_term and cmd == float_cmd then
    if not float_term:is_open() then float_term:open() end
    return
  end
  if float_term then float_term:shutdown() end

  float_cmd = cmd
  float_term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    display_name = "hunk",
    direction = "float",
    close_on_exit = true,
    env = { EDITOR = "nvim --clean --headless -l " .. vim.fn.shellescape(edit_script) },
    float_opts = helpers.term_float_opts(true),
    -- Always give keys to hunk when the float is shown again. Scheduled to
    -- run after toggleterm restores the mode the float was hidden in
    on_open = function(term)
      vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr, nowait = true })
      vim.schedule(function() vim.cmd.startinsert() end)
    end,
    on_exit = function(term)
      if term == float_term then float_term, float_cmd = nil, nil end
    end,
  })
  float_term:open()
end

local subcommands = { "diff", "show", "log", "stash", "open", "status" }

-- :Hunk [args] runs "hunk <args>" in the float (default "diff"). "%" and
-- the like expand to the current file
vim.api.nvim_create_user_command("Hunk", function(ctx)
  local args = vim.trim(ctx.args)
  float_open(args == "" and "diff" or vim.fn.expandcmd(args))
end, {
  nargs = "*",
  complete = function(lead, line)
    if line:match("^%S+%s+%S*$") then
      return vim.tbl_filter(function(s) return vim.startswith(s, lead) end, subcommands)
    end
    return vim.fn.getcompletion(lead, "file")
  end,
})

-- Show or hide the float if it is running, else open a new working tree diff
vim.api.nvim_create_user_command("HunkToggle", function()
  if float_term then float_term:toggle() else float_open("diff") end
end, { nargs = 0 })

vim.api.nvim_create_user_command("HunkClose", function()
  if float_term then float_term:shutdown() end
end, { nargs = 0 })

-- Send hunk's refresh key to the running float
vim.api.nvim_create_user_command("HunkRefresh", function()
  if float_term and float_term.job_id then vim.fn.chansend(float_term.job_id, "r") end
end, { nargs = 0 })

wk.add({
  { "<leader>g",  group = "git" },
  { "<leader>gD", "<cmd>Hunk diff<cr>", desc = "View full diff" }
})

wk.add({
  { "<leader>v",  group = "diff" },
  { "<leader>vv", "<cmd>HunkToggle<cr>",   desc = "Toggle diff view" },
  { "<leader>vt", "<cmd>HunkToggle<cr>",   desc = "Toggle diff view" },
  { "<leader>vo", "<cmd>Hunk diff<cr>",    desc = "Open diff view" },
  { "<leader>vc", "<cmd>HunkClose<cr>",    desc = "Close diff view" },
  { "<leader>vh", "<cmd>Hunk log<cr>",     desc = "Repo history" },
  { "<leader>vf", "<cmd>Hunk log -- %<cr>", desc = "Current file history" },
  { "<leader>vR", "<cmd>HunkRefresh<cr>",  desc = "Refresh" },
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
  -- "..." diffs against the merge base
  float_open("diff " .. vim.fn.shellescape(ref .. "...HEAD"))
end, { desc = "Open PR diff" })
