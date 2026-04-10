vim.pack.add({
  gh("kylechui/nvim-surround"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-sleuth"),
})

require("nvim-surround").setup({})

-- Setup built-in undotree
if not vim.g.vscode then
  helpers = require("helpers")
  vim.opt.undofile = true
  vim.cmd("packadd nvim.undotree")
  vim.keymap.set("n", "<leader>u", function()
    local w, h, c, r = helpers.get_float_size(
      float_width_pct,
      float_height_pct,
      vim.o.columns
    )

    local cmd_string = "call nvim_open_win(nvim_create_buf(v:true, v:true), v:true, "
      .. "{'relative': 'editor', 'width': " .. w
      .. ", 'height': " .. h
      .. ", 'col': " .. c
      .. ", 'row': " .. r
      .. " })"
    
    require("undotree").open({ command = cmd_string, title = "undotree" })
  end, { desc = "Open undotree" })
end
