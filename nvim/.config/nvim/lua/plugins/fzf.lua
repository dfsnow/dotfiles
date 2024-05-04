return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local w = math.floor(vim.o.columns * 0.88)
    local h = math.floor(vim.o.lines * 0.75)
    local r = math.floor((vim.o.lines - h) / 2 - 1)
    local c = math.floor((vim.o.columns - w) / 2 - 1)
    local fzf_lua = require("fzf-lua")
    fzf_lua.setup({
      winopts = {
        height    = 0.85,
        width     = 0.9,
        row       = r,
        col       = c,
        preview   = {
          flip_columns = 80,
          horizontal = "right:50%",
          vertical = "up:50%"
        }
      },
      fzf_opts = { ["--layout"] = "default" },
      actions = { files = { ["default"] = fzf_lua.actions.file_edit } },
      files = {
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
      }
    })
    fzf_lua.register_ui_select()

    -- Custom marks search function
    local previewer = require("fzf-lua.previewer")
    local prev_marks = previewer.buffer_or_file:extend()

    -- function prev_marks:new(o, opts, fzf_win)
    --   prev_marks.marks.super.new(self, o, opts, fzf_win)
    --   return self
    -- end

    _G.fzf_harpoon = function(entries, opts)
      local core = require("fzf-lua.core")
      local config = require("fzf-lua.config")
      opts = config.normalize_opts(opts, "marks")
      if not opts then return end
      opts.previewer = nil
      opts.prompt = "Harpoon> "
      table.sort(entries, function(a, b) return a < b end)
      core.fzf_exec(entries, opts)
    end
  end
}
