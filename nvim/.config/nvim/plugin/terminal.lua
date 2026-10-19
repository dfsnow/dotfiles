vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "Exit terminal mode" })

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Set up terminal buffers",
  group = vim.api.nvim_create_augroup("terminal_setup", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
    vim.opt_local.spell = false
    vim.cmd.startinsert()
  end
})

if vim.g.vscode then return end

vim.pack.add({
  gh("akinsho/toggleterm.nvim"),
})

local helpers = require("helpers")
local Terminal = require("toggleterm.terminal").Terminal
local wk = require("which-key")

-- Size the float the same as the other plugin floats. Functions are
-- used so that the size is calculated again each time the float opens
require("toggleterm").setup({
  shade_terminals = false,
  highlights = {
    NormalFloat = { link = "NormalFloat" },
    FloatBorder = { link = "FloatBorder" },
  },
  float_opts = {
    border = "single",
    width = function() return select(1, helpers.get_float_size()) end,
    height = function() return select(2, helpers.get_float_size()) end,
    col = function() return select(3, helpers.get_float_size()) end,
    row = function() return select(4, helpers.get_float_size()) end,
  }
})

-- Each of these opens a new terminal, so more than one can be open at a time
local function new_term(direction)
  return function()
    Terminal:new({ direction = direction }):toggle()
  end
end

-- Two <esc> exit to normal mode. A third <esc> hides the float
local float_term = Terminal:new({
  direction = "float",
  on_open = function(term)
    vim.keymap.set("n", "<esc>", function() term:close() end,
      { buffer = term.bufnr, desc = "Hide floating terminal" })
  end
})

-- Open lazygit in the git root of the working directory. A new terminal
-- is made each time so that lazygit always opens in the current directory
local function lazygit()
  Terminal:new({
    cmd = "lazygit",
    dir = helpers.cwd_or_git(),
    direction = "float",
    close_on_exit = true,
  }):toggle()
end

wk.add({
  { "<leader>G",  lazygit,                              desc = "Open lazygit" },
  { "<leader>.",  function() float_term:toggle() end,   desc = "Toggle floating terminal" },
  { "<leader>t",  group = "terminal" },
  { "<leader>tt", function() float_term:toggle() end,   desc = "Toggle floating terminal" },
  { "<leader>tn", new_term("tab"),                      desc = "New terminal tab" },
  { "<leader>th", new_term("horizontal"),               desc = "New horizontal terminal" },
  { "<leader>tv", new_term("vertical"),                 desc = "New vertical terminal" },
  { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>",       desc = "Toggle all terminals" },
  { "<leader>ts", "<cmd>TermSelect<cr>",                desc = "Select terminal" },
  { "<leader>tl", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send line to terminal" },
  { "<leader>tl", ":ToggleTermSendVisualSelection<cr>", desc = "Send selection to terminal", mode = "x" },
})
