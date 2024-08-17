return {
  "ibhagwan/fzf-lua",
  version = "*",
  lazy = false,
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf_lua = require("fzf-lua")
    local helpers = require("config.helpers")
    fzf_lua.setup({
      -- Callback function to resize the window when vim size changes
      winopts_fn = function()
        local w, h, c, r = helpers.get_float_size(float_width_pct, float_height_pct)
        local opts = { width = w, height = h, row = r, col = c }
        return opts
      end,
      winopts = {
        backdrop = "NONE",
        preview = {
          flip_columns = 80,
          horizontal = "right:50%",
          vertical = "up:50%"
        }
      },
      fzf_opts = { ["--layout"] = "default" },
      actions = { files = { ["default"] = fzf_lua.actions.file_edit } },
      -- Same options as used in .bashrc, for consistency
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
  end
}
