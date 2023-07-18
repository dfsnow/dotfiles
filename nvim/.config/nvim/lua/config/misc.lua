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

-- Activate wrapping and zen mode by default for certain filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = {"markdown", "txt", "rmd", "qmd", "lazy"},
  callback = function()
    vim.opt_local.list = false
    vim.b.indent_blankline_enabled = false
    vim.b.zen_toggle_flag = true
  end
})
