vim.pack.add({
  gh("folke/flash.nvim"),
  gh("stevearc/oil.nvim"),
  gh("vscode-neovim/vscode-multi-cursor.nvim"),
})

if not vim.g.vscode then
  local oil = require("oil")
  local wk = require("which-key")

  -- <Esc> and <Tab> are set for all plugin floats in lua/autocmds.lua
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
  }
})

-- True while flash.jump() or flash.treesitter() reads keys
local flash_active = false

local function track_flash(fn)
  return function()
    flash_active = true
    local ok, err = pcall(fn)
    flash_active = false
    if not ok then error(err, 0) end
  end
end

vim.keymap.set({ "n", "x", "o" }, "<space>", track_flash(flash.jump), { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "<leader><space>", track_flash(flash.treesitter), { desc = "Flash Treesitter" })

-- Make <Esc> cancel only Flash, even in a floating window. The next <Esc>
-- then works as usual, for example to close the window.
-- - Flash jumps read <Esc> themselves, then send another <Esc>. Discard it.
-- - Flash labels after f/F/t/T stay visible. Hide them and discard the <Esc>.
-- Only discard <Esc> in normal mode, so that one <Esc> still leaves visual
-- mode and cancels an operator.
-- vim.on_key gets the typed key even when a buffer mapping replaces it.
-- https://github.com/folke/flash.nvim/issues/401#issuecomment-2676690290
local flash_char = require("flash.plugins.char")
local esc = vim.keycode("<esc>")
local discard_next_esc = false
vim.on_key(function(_, typed)
  -- Ignore keys that you did not type, such as keys sent by a jump
  if typed == "" then return end
  if typed ~= esc then
    discard_next_esc = false
    return
  end
  if flash_active then
    discard_next_esc = true
    return
  end

  local discard = discard_next_esc
  discard_next_esc = false
  -- Skip while f/F/t/T waits for a target, so that <Esc> cancels it
  if flash_char.visible() and not flash_char.jumping then
    flash_char.state:hide()
    discard = true
  end
  if discard and vim.fn.mode(1) == "n" then return "" end
end, vim.api.nvim_create_namespace("flash_esc"))

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
