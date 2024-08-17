-- Use .vimrc as a base file
vim.cmd("source ~/.vimrc")

-- Set global floating window size
_G.float_width_pct = 0.88
_G.float_height_pct = 0.75

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

-- Load all nvim plugins, mappings, and autocmds
require("lazy").setup(
  "plugins",
  {
    ui = {
      border = "rounded",
      title = "Lazy",
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
require("config/autocmds")
