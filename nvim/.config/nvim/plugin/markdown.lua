if vim.g.vscode then return end

vim.g.render_markdown_config = {
  completions = { lsp = { enabled = true } },
  sign = { enabled = false },
  heading = { backgrounds = {} },
  -- Keep the code color but drop the background
  code = { highlight_inline = "@markup.raw" }
}

vim.pack.add({
  gh("MeanderingProgrammer/render-markdown.nvim"),
})

vim.keymap.set("n", "<leader>R", function()
  require("render-markdown").toggle()
end, { desc = "Toggle markdown rendering" })
