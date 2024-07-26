-- Disable performance hogs for large files
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable performance hogs for large files",
  group = vim.api.nvim_create_augroup("big_file_perf", { clear = false }),
  callback = function(opts)
    if is_big_file(_, opts.buf) then
      require("ibl").setup_buffer(0, { enabled = false })
      require("cmp").setup({ completion = { autocomplete = false } })
      vim.opt_local.list = false
      vim.opt_local.foldenable = false
      vim.opt_local.wrap = false
      vim.opt_local.syntax = ""
    end
  end
})

-- Disable treesitter folding for large files
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable treesitter folding for large files",
  group = vim.api.nvim_create_augroup("big_file_perf", { clear = false }),
  callback = function(opts)
    if not is_big_file(_, opts.buf) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end
  end
})

-- Activate wrapping and zen mode by default for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "txt", "rmd", "qmd", "lazy" },
  desc = "Start in zen mode for text files",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  callback = function()
    vim.opt_local.list = false
    require("ibl").setup_buffer(0, { enabled = false })
    vim.b.zen_toggle_flag = true
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end
})

-- Exit lazy.nvim using escape
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazy",
  desc = "Quit lazy with <esc>",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  callback = function()
    vim.keymap.set(
      "n",
      "<esc>",
      function() vim.api.nvim_win_close(0, false) end,
      { buffer = true, nowait = true }
    )
  end
})

-- Set the size and position of floating windows. Doesn't work for fzf-lua
-- since that uses multiple windows
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "Resize plugin floating windows",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  pattern = { "mason", "lazy", "oil", "copilot-*" },
  callback = function()
    if vim.api.nvim_win_get_config(0).relative == "editor" then
      local w, h, c, r = get_float_size(float_width_pct, float_height_pct)
      vim.api.nvim_win_set_config(0, {
        relative = "editor",
        width = w,
        height = h,
        row = r,
        col = c
      })
    end
  end
})

-- Automatically highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 700 }
  end
})

-- Automatically lint on save
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    require("lint").try_lint()
  end
})
