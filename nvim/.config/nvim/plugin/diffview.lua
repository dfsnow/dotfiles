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
      ["<leader>gp"] = "[c",
      ["<leader>gn"] = "]c",
      ["K"] = actions.scroll_view(-scroll_amount),
      ["J"] = actions.scroll_view(scroll_amount)
    },
    file_panel = {
      ["K"] = actions.scroll_view(-scroll_amount),
      ["J"] = actions.scroll_view(scroll_amount)
    }
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
