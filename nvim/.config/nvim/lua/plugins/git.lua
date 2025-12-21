return {
  {
    "lewis6991/gitsigns.nvim",
    version = "*",
    cond = not vim.g.vscode,
    config = function()
      local gitsigns = require("gitsigns")
      local wk = require("which-key")
      local fzf_lua = require("fzf-lua")
      local helpers = require("config.helpers")

      gitsigns.setup({
        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "-" },
          topdelete    = { text = "‾" },
          changedelete = { text = "_" },
          untracked    = { text = "┆" },
        },
        preview_config = { border = "single" }
      })

      wk.add({
        { "<leader>g",  group = "git" },
        { "<leader>gb", gitsigns.blame_line,      desc = "View line blame" },
        { "<leader>gt", gitsigns.toggle_signs,    desc = "Toggle git signs" },
        { "<leader>gd", gitsigns.preview_hunk,    desc = "View diff preview" },
        { "<leader>gD", gitsigns.diffthis,        desc = "View full diff" },
        { "<leader>gn", gitsigns.next_hunk,       desc = "Next hunk" },
        { "<leader>gp", gitsigns.prev_hunk,       desc = "Previous hunk" },
        { "<leader>gu", gitsigns.reset_hunk,      desc = "Undo hunk" },
        { "<leader>gU", gitsigns.undo_stage_hunk, desc = "Undo stage hunk" },
        { "<leader>gs", gitsigns.stage_hunk,      desc = "Stage hunk" },
        { "<leader>ga", gitsigns.stage_hunk,      desc = "Stage hunk" },
        { "<leader>gS", gitsigns.stage_buffer,    desc = "Stage buffer" },
        { "<leader>gh", gitsigns.toggle_linehl,   desc = "Toggle highlights" },
      })
    end
  }
}
