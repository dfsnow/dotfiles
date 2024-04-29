return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local w = math.floor(vim.o.columns * 0.88)
    local h = math.floor(vim.o.lines * 0.75)
    local r = math.floor((vim.o.lines - h) / 2 - 1)
    local c = math.floor((vim.o.columns - w) / 2 - 1)
    require("fzf-lua").setup({
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
    require("fzf-lua").register_ui_select()
  end
}
