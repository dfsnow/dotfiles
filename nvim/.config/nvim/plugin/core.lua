vim.pack.add({
  gh("kylechui/nvim-surround"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-sleuth"),
})

require("nvim-surround").setup({})

-- Setup built-in undotree
if not vim.g.vscode then
  local helpers = require("helpers")
  vim.opt.undofile = true
  vim.cmd("packadd nvim.undotree")
  vim.keymap.set("n", "<leader>u", function()
    local w, h, c, r = helpers.get_float_size()
    local cmd_string = string.format(
      "call nvim_open_win(nvim_create_buf(v:true, v:true), v:true, "
      .. "{'relative': 'editor', 'width': %d, 'height': %d, 'col': %d, 'row': %d})",
      w, h, c, r
    )
    require("undotree").open({ command = cmd_string, title = "undotree" })
  end, { desc = "Open undotree" })
end
