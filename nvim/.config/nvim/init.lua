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

-- Load all nvim plugins
require("config/filetypes")
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

-- Load additional configuration and settings
require("config/helpers")
require("config/autocmds")
require("config/mappings")
