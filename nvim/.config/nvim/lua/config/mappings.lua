local wk = require("which-key")
local helpers = require("config.helpers")

-- Non-leader
wk.add({
  { "g",       group = "misc" },
  { "z",       group = "folding" },
  { "<esc>",   helpers.close_floating_windows,     desc = "Close floating windows" },
  { "<c-A>",   desc = "Increment up" },
  { "<c-X>",   desc = "Increment down" },
  { "J",       desc = "Join lines" },
  { "<tab>",   desc = "Next buffer" },
  { "<s-tab>", desc = "Previous buffer" },
  { ".",       desc = "Repeat last command" },
  { "*",       desc = "Select current word" },
  { "m",       desc = "Set mark at current line" },
  { "q",       desc = "Begin recording macro" },
  { "@",       desc = "Execute macro" },
  { "&",       desc = "Repeat substitution" },
  { "~",       desc = "Toggle current case" },
  { "%",       desc = "Go to matching bracket" },
  { "R",       desc = "Replace with last yank" },
  { "u",       desc = "Undo action" },
  { "U",       desc = "Redo action" },
  { "g;",      desc = "Go to last edited position" },
  { "i",       desc = "Insert mode" },
  {
    hidden = true,
    { "p" },
    { "P" },
    { "f" },
    { "F" },
    { "t" },
    { "T" },
    { ">" },
    { "<" },
    { "0" },
    { "j" },
    { "Y" },
    { "!" },
    { "[" },
    { "]" },
    { "<bs>" },
    { "<cr>" },
    { "<c-L>" },
    { "c" },
    { "d" },
    { "y" },
    { "<snr>" },
    { "gc" },
    { "<ScrollWheelUp>" },
    { "<ScrollWheelDown>" },
    { "<PageUp>" },
    { "<PageDown>" }
  }
})

-- Base leader
wk.add({
  { "<leader>",         group = "leader" },
  { "<leader>L",        require("lazy").home,                                         desc = "Open Lazy" },
  { "<leader>n",        "<cmd>setlocal wrap!<cr>",                                    desc = "Toggle word wrap" },
  { "<leader>r",        "<cmd>silent !tmux send-keys -t {bottom} Up Enter<cr>",       desc = "Run last tmux command" },
  { "<leader>Q",        desc = "Exit without saving" },
  { "<leader>x",        desc = "Close buffer" },
  { "<leader><space>",  desc = "Flash treesitter" },
  { "<leader>-",        desc = "New vertical split" },
  { "<leader>_",        desc = "New horizontal split" },
  { "<leader><tab>",    desc = "Next window" },
  { "<leader><s-tab>",  desc = "Previous window" },
  {
    mode = { "x", "n" },
    { "<leader>p",    desc = "Paste from clipboard" },
    { "<leader>y",    desc = "Yank to clipboard" },
    { "<leader><cr>", desc = "Send to tmux" },
    { "<leader>c",    desc = "Toggle comment" }
  },
  {
    hidden = true,
    { "<leader><esc>" },
    { "<leader>P" },
    { "<leader>q" },
    { "<leader>j" },
    { "<leader>h" },
    { "<leader>k" },
    { "<leader>l" },
    { "<leader>w" },
    { "<leader>W" },
    { "<leader>Y" },
    { "<leader>yy" }
  }
})

-- Buffer
wk.add({
  { "<leader>b",  group = "buffer" },
  { "<leader>bv", "<cmd>vnew<cr>",        desc = "New vertical split" },
  { "<leader>bh", "<cmd>new<cr>",         desc = "New horizontal split" },
  { "<leader>bb", desc = "New (no split)" },
  { "<leader>bn", desc = "New (no split)" },
  { "<leader>bc", desc = "Close" }
})

-- Spelling
wk.add({
  { "<leader>s",  group = "spelling" },
  { "<leader>ss", desc = "Toggle spell check" },
  { "<leader>sn", "]s",                       desc = "Next misspelling" },
  { "<leader>sp", "[s",                       desc = "Previous misspelling" },
  { "<leader>sa", "zg",                       desc = "Add to dictionary" },
  { "<leader>sf", plugin = "spelling",        desc = "Lookup in dictionary" },
  { "<leader>s?", plugin = "spelling",        desc = "Lookup in dictionary" }
})

-- Proper indentation on empty lines
vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- No yanking empty lines
vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })

-- Better, space-aware line joins
vim.keymap.set({ "n", "v" }, "<c-j>", function()
  vim.cmd("normal! mzJ")
  local col = vim.fn.col(".")
  local context = string.sub(vim.fn.getline("."), col - 1, col + 1)
  if context == ") ." or context == ") :" or context:match("%( .") or context:match(". ,") or context:match("%w %.") then
    vim.cmd("undojoin | normal! x")
  elseif context == ",)" then
    vim.cmd("undojoin | normal! hx")
  end
  vim.cmd("normal! `z")
end)
