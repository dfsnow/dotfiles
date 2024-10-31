M = {}

-- Filetypes for which to load various plugins lazily
M.treesitter_parsers = {
  "awk",
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "dockerfile",
  "gitcommit", "gitignore", "gitattributes", "git_config",
  "go",
  "javascript",
  "json",
  "jq",
  "julia",
  "html",
  "lua",
  "markdown", "markdown_inline",
  "python",
  "query",
  "r",
  "rust",
  "sql",
  "terraform",
  "toml",
  "typescript",
  "vim", "vimdoc",
  "yaml"
}

-- Concatenate a table of languages which don't have parsers, but which
-- we want to activate treesitter for
M.treesitter_ft = {
  "sh",
  "css", "scss", "less",
  "quarto", "rmd"
}

for _, v in ipairs(M.treesitter_parsers) do
  table.insert(M.treesitter_ft, v)
end

M.lsp_ft = {
  "bash", "sh",
  "css", "scss", "less",
  "dockerfile",
  "gitcommit",
  "javascript",
  "json",
  "html",
  "lua",
  "markdown",
  "python",
  "rmd", "quarto",
  "r",
  "rust",
  "sql",
  "terraform", "tf",
  "yaml"
}

M.format_ft = {
  "bash", "sh",
  "json",
  "sql",
  "yaml"
}

M.lint_ft = {
  "bash", "sh",
  "css", "scss", "less",
  "html",
  "dockerfile",
  "gitcommit",
  "markdown",
  "sql",
  "terraform", "tf",
  "yaml"
}

M.smart_send_ft = {
  "python", "r"
}

return M
