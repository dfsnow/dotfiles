-- Enable bytecode cache for faster startup
vim.loader.enable()

-- Use .vimrc as a base file
vim.cmd("source ~/.vimrc")

-- Set global floating window size
_G.float_width_pct = 0.88
_G.float_height_pct = 0.83

-- GitHub link shortener
_G.gh = function(x) return "https://github.com/" .. x end

-- Disable certain interfering options in VS Code
if vim.g.vscode then
  vim.opt.spell = false
end

require("mappings")
require("autocmds")
