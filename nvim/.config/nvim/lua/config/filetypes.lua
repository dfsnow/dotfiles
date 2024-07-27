-- Filetypes for which to load various plugins lazily
_G.treesitter_parsers = {
  "awk",
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "dockerfile",
  "gitcommit", "gitignore", "gitattributes",
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
_G.treesitter_ft = {
  "sh",
  "css", "scss", "less",
  "quarto", "rmd"
}

for _, v in ipairs(_G.treesitter_parsers) do
  table.insert(_G.treesitter_ft, v)
end

_G.lsp_ft = {
  "bash", "sh",
  "css", "scss", "less",
  "dockerfile",
  "gitcommit",
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

_G.format_ft = {
  "bash", "sh",
  "json",
  "sql",
  "yaml"
}

_G.lint_ft = {
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
