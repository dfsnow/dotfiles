vim.pack.add({
  gh("kylechui/nvim-surround"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-sleuth"),
})

-- Setup built-in undotree
helpers = require("helpers")
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

        vim.api.nvim_win_set_config(0, {
          relative = "editor",
          border = "single",
          width = w,
          height = h,
          row = r,
          col = c
        })
end, { desc = "Open undotree" })

require("nvim-surround").setup({})
