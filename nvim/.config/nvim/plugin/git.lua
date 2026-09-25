if vim.g.vscode then return end

vim.pack.add({
  gh("lewis6991/gitsigns.nvim"),
})

local gitsigns = require("gitsigns")
local wk = require("which-key")

gitsigns.setup({
  signs = {
    add          = { text = "+" },
    change       = { text = "~" },
    delete       = { text = "-" },
    topdelete    = { text = "‾" },
    changedelete = { text = "_" },
    untracked    = { text = "┆" },
  }
})

-- stage_hunk unstages the hunk if it is already staged
wk.add({
  { "<leader>g",  group = "git" },
  { "<leader>gb", gitsigns.blame_line,      desc = "View line blame" },
  { "<leader>gt", gitsigns.toggle_signs,    desc = "Toggle git signs" },
  { "<leader>gd", gitsigns.preview_hunk,    desc = "View diff preview" },
  { "<leader>gn", function() gitsigns.nav_hunk("next") end, desc = "Next hunk" },
  { "<leader>gp", function() gitsigns.nav_hunk("prev") end, desc = "Previous hunk" },
  { "<leader>gu", gitsigns.reset_hunk,      desc = "Undo hunk" },
  { "<leader>gs", gitsigns.stage_hunk,      desc = "Stage/unstage hunk" },
  { "<leader>ga", gitsigns.stage_hunk,      desc = "Stage/unstage hunk" },
  { "<leader>gS", gitsigns.stage_buffer,    desc = "Stage buffer" },
  { "<leader>gh", gitsigns.toggle_linehl,   desc = "Toggle highlights" },
})
