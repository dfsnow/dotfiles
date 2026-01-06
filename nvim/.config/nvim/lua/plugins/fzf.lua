return {
  "ibhagwan/fzf-lua",
  version = "*",
  lazy = false,
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cond = not vim.g.vscode,
  config = function()
    local fzf_lua = require("fzf-lua")
    local wk = require("which-key")
    local helpers = require("config.helpers")

    local function grep_cwd()
      fzf_lua.grep_project({ cwd = helpers.cwd_or_git() })
    end

    fzf_lua.setup({
      -- Callback function to resize the window when vim size changes
      winopts = function()
        local w, h, c, r = helpers.get_float_size(
          float_width_pct,
          float_height_pct,
          vim.o.columns
        )
        local opts = {
          width = w,
          height = h,
          row = r,
          col = c,
          border = "single",
          backdrop = "NONE",
          preview = {
            border = "single",
            flip_columns = 80,
            horizontal = "right:50%",
            vertical = "up:50%",
            layout = "vertical",
          }
        }
        return opts
      end,
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        }
      },
      oldfiles = { include_current_session = true },
      fzf_opts = { ["--layout"] = "default" },
      actions = {
        files = {
          ["default"] = fzf_lua.actions.file_edit,
        }
      },
      keymap = {
        builtin = {
          ["<S-j>"] = "preview-page-down",
          ["<S-k>"] = "preview-page-up"
        }
      },
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

    wk.add({
      { ";",                fzf_lua.resume,                                               desc = "Resume search" },
      { "<c-r>",            fzf_lua.command_history,                                      desc = "Search command history" },
      { "<c-t>",            fzf_lua.files,                                                desc = "Search files" },
      { "<leader>/",        grep_cwd,                                                     desc = "Grep in project" },
      { "<leader><leader>", function() fzf_lua.files({ cwd = helpers.cwd_or_git() }) end, desc = "Search project files" },
      { "<leader>;",        helpers.fzf_dirs,                                             desc = "Change cwd" },
      { "<leader>*",        fzf_lua.grep_cword,                                           desc = "Grep current word" },
      { "<leader>bf",       fzf_lua.buffers,                                              desc = "Search buffers" },
    })

    wk.add({
      { "<leader>f",  group = "search" },
      { "<leader>ff", fzf_lua.files,           desc = "All files" },
      { "<leader>fo", fzf_lua.oldfiles,        desc = "Old files" },
      { "<leader>fb", fzf_lua.buffers,         desc = "Buffers" },
      { "<leader>fw", fzf_lua.grep_cword,      desc = "Grep current word" },
      { "<leader>fm", fzf_lua.marks,           desc = "Marks" },
      { "<leader>fr", fzf_lua.command_history, desc = "Command history" },
      { "<leader>fh", fzf_lua.helptags,        desc = "Helptags" },
      { "<leader>fs", fzf_lua.grep_curbuf,     desc = "Grep in buffer" },
      { "<leader>fS", grep_cwd,                desc = "Grep in project" }
    })

    wk.add({
      cond = helpers.get_git_exit(),
      { "<leader>gf",  group = "search" },
      { "<leader>gfc", fzf_lua.git_commits,  desc = "Commits" },
      { "<leader>gfC", fzf_lua.git_bcommits, desc = "Buffer commits" },
      { "<leader>gfb", fzf_lua.git_branches, desc = "Branches" },
      { "<leader>gfd", fzf_lua.git_status,   desc = "Diff" },
      { "<leader>gfS", fzf_lua.git_stash,    desc = "Stash" },
      { "<leader>fg",  fzf_lua.git_files,    desc = "Git files" },
      { "<leader>fd",  fzf_lua.git_status,   desc = "Git diff" },
      { "<leader>fc",  fzf_lua.git_commits,  desc = "Git commits" },
      { "<leader>gg",  fzf_lua.git_status,   desc = "Search git changes" }
    })
  end
}
