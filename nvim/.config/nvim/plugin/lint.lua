vim.pack.add({
  gh("mfussenegger/nvim-lint"),
})

if not vim.g.vscode then
  local lint = require("lint")
  local wk = require("which-key")

  vim.filetype.add({
    pattern = {
      [".*/%.github/workflows/.*%.yaml"] = "yaml.ghaction",
      [".*/%.github/workflows/.*%.yml"] = "yaml.ghaction",
    }
  })

  lint.linters_by_ft = {
    dockerfile = { "hadolint" },
    markdown = { "markdownlint-cli2" },
    terraform = { "tflint" },
    yaml = { "yamllint" },
    ["yaml.ghaction"] = { "actionlint" },
  }

  wk.add({
    { "<leader>dL", function() lint.try_lint() end, desc = "Lint buffer" },
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    desc = "Lint supported file types",
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    callback = function()
      lint.try_lint()
    end,
  })
end
