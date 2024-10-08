local helpers = require("config.helpers")

-- Disable performance hogs for large files
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable performance hogs for large files",
  group = vim.api.nvim_create_augroup("big_file_perf", { clear = false }),
  callback = function(opts)
    if helpers.is_big_file(_, opts.buf) then
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
    if not helpers.is_big_file(_, opts.buf) then
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

-- Set the size and position of certain floating windows automatically
-- Note that fzf-lua uses a separate callback function for its floating window
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "Resize plugin floating windows",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  pattern = { "mason", "lazy", "oil", "copilot-*" },
  callback = function()
    if vim.api.nvim_win_get_config(0).relative == "editor" then
      local w, h, c, r = helpers.get_float_size(float_width_pct, float_height_pct)
      vim.api.nvim_win_set_config(0, {
        relative = "editor",
        width = w,
        height = h,
        row = r,
        col = c
      })
    end

    -- Remap table to prevent buffer switching in floating windows
    vim.keymap.set("n", "<tab>", "j", { buffer = true })
    vim.keymap.set("n", "<s-tab>", "k", { buffer = true })
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

-- Always re-open the Copilot chat window in the same position
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function(opts)
    local prev_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
    if prev_line > 1
        and prev_line <= vim.api.nvim_buf_line_count(opts.buf)
    then
      vim.api.nvim_feedkeys([[g`"]], "n", true)
    end
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

-- Enable smart send via SLIME in supported files
vim.api.nvim_create_autocmd("FileType", {
  pattern = require("config.filetypes").smart_send_ft,
  desc = "Enable smart send via vim-slime",
  group = vim.api.nvim_create_augroup("mod_buffer", { clear = false }),
  callback = function()
    require("which-key").add({
      {
        { "<leader><cr>", helpers.smart_send, desc = "Smart send to tmux" },
        group = "leader",
        mode = "n",
        silent = true,
        noremap = true
      }
    })
  end
})
