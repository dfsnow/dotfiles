-- Use .vimrc as a base file
vim.cmd("source ~/.vimrc")

-- Load lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load self-maintained helpers, dicts, etc.
require("config/helpers")
require("config/filetypes")
require("config/autocmds")

-- Set global floating window size before plugin load
set_float_size()

-- Load all nvim plugins and mappings
require("lazy").setup(
  "plugins",
  {
    ui = {
      border = "rounded",
      size = { width = 0.88, height = 0.75 },
      title = "Lazy Plugins",
      title_pos = "left",
      backdrop = 100
    },
    rocks = {
      hererocks = false,
      enabled = false
    }
  }
)
require("config/mappings")
