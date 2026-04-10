vim.pack.add({
  gh("folke/flash.nvim"),
  gh("stevearc/oil.nvim"),
  gh("vscode-neovim/vscode-multi-cursor.nvim"),
})

if not vim.g.vscode then
  local oil = require("oil")
  local wk = require("which-key")

  oil.setup({
    default_file_explorer = true,
    columns = {
      "permissions",
      "size",
      "mtime",
      "icon"
    },
    view_options = { show_hidden = true, },
    buf_options = { bufhidden = "unload" },
    win_options = { colorcolumn = "0" },
    use_default_keymaps = false,
    keymaps = {
      ["-"] = "actions.parent",
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<BS>"] = "actions.parent",
      ["<Esc>"] = "actions.close",
      ["<Tab>"] = "actions.close",
      ["<leader>-"] = "actions.select_vsplit",
      ["<leader>_"] = "actions.select_split",
      ["<leader><space>"] = "actions.preview",
      ["."] = "actions.open_cwd",
      ["<leader>."] = "actions.tcd",
    }
  })

  wk.add({
    { "-",         function() oil.open_float() end,    desc = "Open parent directory" },
    { "<leader>.", function() oil.open_float(".") end, desc = "Open working directory" }
  })
end

local flash = require("flash")
flash.setup({
  search = {
    exclude = {
      "blink-cmp-menu",
      "blink-cmp-documentation",
      "blink-cmp-signature"
    }
  },
  modes = { char = { enabled = true } }
})

vim.keymap.set({ "n", "x", "o" }, "<space>", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "<leader><space>", function() flash.treesitter() end, { desc = "Flash Treesitter" })
-- Fix for not escaping f/F
-- https://github.com/folke/flash.nvim/issues/401#issuecomment-2676690290
vim.keymap.set({ "n", "x", "o" }, "<esc>", function()
  local char = require("flash.plugins.char")
  if char.state then
    char.state:hide()
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
end, { desc = "Cancel Flash Char" })

if vim.g.vscode then
  local mc = require("vscode-multi-cursor")
  vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
    mc.addSelectionToNextFindMatch()
  end)
  vim.keymap.set({ "n", "x", "i" }, "<C-f>", function()
    mc.addSelectionToPreviousFindMatch()
  end)
  vim.keymap.set({ "n", "x", "i" }, "<C-l>", function()
    mc.selectHighlights()
  end)
end
