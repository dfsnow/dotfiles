local helpers = require("config.helpers")

-- Disable performance hogs for large files
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable performance hogs for large files",
  group = vim.api.nvim_create_augroup("big_file_perf", { clear = false }),
  callback = function(opts)
    if helpers.is_big_file(_, opts.buf) then
      require("ibl").setup_buffer(0, { enabled = false })
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
    if not helpers.is_big_file(_, opts.buf) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end
  end
})

-- Set the size and position of certain floating windows automatically
-- Note that fzf-lua uses a separate callback function for its floating window
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "Resize plugin floating windows",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  pattern = { "lazy", "oil" },
  callback = function()
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.relative ~= "" then
      if win_config.relative == "editor" then
        local w, h, c, r = helpers.get_float_size(
          float_width_pct,
          float_height_pct,
          vim.o.columns
        )
        vim.api.nvim_win_set_config(0, {
          relative = "editor",
          border = "single",
          width = w,
          height = h,
          row = r,
          col = c
        })
      end
    end

    -- Remap table to prevent buffer switching in floating windows
    vim.keymap.set("n", "<tab>", "j", { buffer = true })
    vim.keymap.set("n", "<s-tab>", "k", { buffer = true })

    -- Remap Escape to quit floating windows
    vim.keymap.set("n", "<esc>", "<cmd>q<cr>", { buffer = true })
  end
})

-- Automatically highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700, priority = 10000 })
  end
})

-- Disable conceal in certain markdown buffers and help files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "markdown" },
  desc = "Don't conceal in help and markdown files",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  callback = function()
    vim.wo.conceallevel = 0
  end
})
