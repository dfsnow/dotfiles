return {
  "ibhagwan/fzf-lua",
  version = "*",
  lazy = false,
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup({
      winopts_fn = function()
        local w, h, c, r = get_float_size(float_width_pct, float_height_pct)
        local opts = { width = w, height = h, row = r, col = c }
        return opts
      end,
      winopts = {
        backdrop = "NONE",
        preview  = {
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

    -- Helper to replicate Alt-C function inside vim
    _G.fzf_dirs = function(opts)
      opts = opts or {}
      opts.fzf_cli_args = "--walker=dir --scheme=path"
      opts.prompt = "Dir> "
      opts.actions = {
        ["default"] = function(selected)
          vim.cmd("cd " .. selected[1])
        end
      }
      fzf_lua.fzf_exec(os.getenv("FZF_ALT_C_COMMAND"), opts)
    end

    -- Helper used to display the cwd in the statusline via lualine
    _G.fzf_cwd = function()
      local path = vim.loop.cwd()
      path = fzf_lua.path.HOME_to_tilde(path)
      path = fzf_lua.path.shorten(path)
      return path
    end
  end
}
