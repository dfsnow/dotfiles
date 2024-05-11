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

require("config/misc")
require("config/helpers")
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
    }
  }
)

-- Exit lazy.nvim using escape
local user_grp = vim.api.nvim_create_augroup("LazyUserGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazy",
  desc = "Quit lazy with <esc>",
  callback = function()
    vim.keymap.set(
      "n",
      "<esc>",
      function() vim.api.nvim_win_close(0, false) end,
      { buffer = true, nowait = true }
    )
  end,
  group = user_grp,
})
