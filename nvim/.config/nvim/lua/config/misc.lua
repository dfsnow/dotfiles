-- Disable folding by default
vim.opt.foldenable = false

-- Add floating windows for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = ""
  },
})

-- Add rounded borders to floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)

-- Add diagnostic floating window
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

-- Disable performance hogs for large files
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable performance hogs for large files",
  group = vim.api.nvim_create_augroup("BigFile", { clear = false }),
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

-- Automatically highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 700 }
  end
})
