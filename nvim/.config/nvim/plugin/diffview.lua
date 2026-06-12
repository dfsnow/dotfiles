vim.pack.add({
  gh("folke/which-key.nvim"),
  gh("dlyongemallo/diffview-plus.nvim"),
})

if not vim.g.vscode then
  local wk = require("which-key")
  local actions = require("diffview.actions")
  local scroll_amount = 0.10

  require("diffview").setup({
    enhanced_diff_hl = true,
    file_panel = {
      show_branch_name = true,
      always_show_sections = true,
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

    local base
    local pr = vim.fn.systemlist({ "gh", "pr", "view", "--json", "baseRefName", "--jq", ".baseRefName" })
    if vim.v.shell_error == 0 and pr[1] ~= nil and pr[1] ~= "" then
      base = pr[1]
    else
      base = ref_exists("main") and "main" or "master"
    end

    -- Compare against the remote base if it's tracked, else the local branch
    local ref = ref_exists("origin/" .. base) and ("origin/" .. base) or base
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
end
