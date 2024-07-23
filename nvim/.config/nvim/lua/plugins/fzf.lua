return {
  "ibhagwan/fzf-lua",
  version = "*",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup({
      winopts = {
        height  = float_height,
        width   = float_width,
        row     = float_row,
        col     = float_col,
        preview = {
          flip_columns = 80,
          horizontal = "right:50%",
          vertical = "up:50%"
        }
      },
      fzf_opts = { ["--layout"] = "default" },
      actions = { files = { ["default"] = fzf_lua.actions.file_edit } },
      files = {
        formatter = "path.filename_first",
        fd_opts =
            "--color=never --type f --hidden --follow " ..
            "--exclude .git --exclude node_modules --exclude renv"
      },
      grep = {
        rg_opts =
            "--hidden --column --line-number --no-heading " ..
            "--color=always --smart-case --max-columns=4096 " ..
            "-g '!{.npm,.rustup,.tldrc,.tldr,.cargo,.git}/' " ..
            "-g '!{node_modules,renv}/' -e"
      },
      git = {
        files = {
          formatter = "path.filename_first"
        }
      }
    })
    fzf_lua.register_ui_select()
    -- Hack to disable background tint
    vim.cmd("highlight FzfLuaBackdrop NONE")
  end
}
