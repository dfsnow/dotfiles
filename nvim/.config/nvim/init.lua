-- Enable bytecode cache for faster startup
vim.loader.enable()

-- Use .vimrc as a base file
vim.cmd("source ~/.vimrc")

-- Use the same border for all floating windows that support 'winborder'
vim.o.winborder = "single"

-- GitHub link shortener
_G.gh = function(x) return "https://github.com/" .. x end

-- Disable certain interfering options in VS Code
if vim.g.vscode then
  vim.opt.spell = false
end

require("mappings")
require("autocmds")
