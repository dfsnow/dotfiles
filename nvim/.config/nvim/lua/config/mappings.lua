local wk = require("which-key")

-- Non-leader
wk.add({
  { "g",       group = "misc" },
  { "z",       group = "folding" },
  { "-",       "<cmd>lua require('oil').open_float()<cr>", desc = "Open parent directory" },
  { "<c-r>",   "<cmd>FzfLua command_history<cr>",          desc = "Search command history" },
  { "<c-t>",   "<cmd>FzfLua files<cr>",                    desc = "Search files" },
  { "<m-c>",   function() fzf_dirs() end,                  desc = "Search dirs" },
  { "<c-A>",   desc = "Increment up" },
  { "<c-X>",   desc = "Increment down" },
  { "<tab>",   desc = "Next buffer" },
  { "<s-tab>", desc = "Previous buffer" },
  { ".",       desc = "Repeat last command" },
  { "*",       desc = "Select current word" },
  { "m",       desc = "Set mark at current line" },
  { "q",       desc = "Begin recording macro" },
  { "@",       desc = "Execute macro" },
  { "~",       desc = "Toggle current case" },
  { "%",       desc = "Go to matching bracket" },
  { "R",       desc = "Replace with last yank" },
  { "u",       desc = "Undo" },
  { "U",       desc = "Redo" },
  { ";",       desc = "Repeat last move" },
  { "J",       desc = "Join lines" },
  { "K",       desc = "Show hover info" },
  { "g;",      desc = "Go to last edited position" },
  { "?",       desc = "Open Copilot Chat" },
  {
    hidden = true,
    { "f" },
    { "F" },
    { "t" },
    { "T" },
    { ">" },
    { "<" },
    { "&" },
    { "0" },
    { "i" },
    { "j" },
    { "Y" },
    { "!" },
    { "[" },
    { "]" },
    { "<bs>" },
    { "<cr>" },
    { "<c-L>" },
    { "c" },
    { "d" },
    { "y" },
    { "<snr>" },
    { "gc" }
  }
})

-- Base leader
wk.add({
  { "<leader>",          group = "leader" },
  { "<leader>L",         "<cmd>Lazy<cr>",                                               desc = "Open Lazy" },
  { "<leader>m",         "<cmd>lua toggle_cmp()<cr>",                                   desc = "Toggle completion" },
  { "<leader>n",         "<cmd>setlocal wrap!<cr>",                                     desc = "Toggle word wrap" },
  { "<leader>Z",         "<cmd>lua toggle_zen_mode()<cr>",                              desc = "Toggle Zen mode" },
  { "<leader>/",         "<cmd>FzfLua grep_curbuf<cr>",                                 desc = "Search current buffer" },
  { "<leader><leader>",  "<cmd>lua require('fzf-lua').files({cwd = cwd_or_git()})<cr>", desc = "Search project files" },
  { "<leader>.",         "<cmd>lua require('oil').open_float('.')<cr>",                 desc = "Open working directory" },
  { "<leader>Q",         desc = "Exit without saving" },
  { "<leader>x",         desc = "Delete buffer" },
  { "<leader>M",         desc = "Open Mason" },
  { "<leader><space>",   desc = "Flash treesitter" },
  { "<leader><s-space>", desc = "Toggle Flash search" },
  { "<leader>-",         desc = "New vertical split" },
  { "<leader>_",         desc = "New horizontal split" },
  { "<leader><tab>",     desc = "Next window" },
  { "<leader><s-tab>",   desc = "Previous window" },
  { "<leader>?",         desc = "Open Copilot prompts" },
  {
    mode = { "x", "n" },
    { "<leader>p",    desc = "Paste from clipboard" },
    { "<leader>y",    desc = "Yank to clipboard" },
    { "<leader><cr>", desc = "Send to tmux" },
    { "<leader>c",    desc = "Toggle comment" }
  },
  {
    hidden = true,
    { "<leader>P" },
    { "<leader>q" },
    { "<leader>j" },
    { "<leader>h" },
    { "<leader>k" },
    { "<leader>l" },
    { "<leader>w" },
    { "<leader>W" },
    { "<leader>Y" },
    { "<leader>yy" }
  }
})

-- Buffer
wk.add({
  { "<leader>b",  group = "buffer" },
  { "<leader>bv", "<cmd>vnew<cr>",           desc = "New vertical split" },
  { "<leader>bh", "<cmd>new<cr>",            desc = "New horizontal split" },
  { "<leader>bf", "<cmd>FzfLua buffers<cr>", desc = "Search buffers" },
  { "<leader>bb", desc = "New (no split)" },
  { "<leader>bn", desc = "New (no split)" },
  { "<leader>bc", desc = "Close" }
})

-- LSP
wk.add({
  { "<leader>d",  group = "lsp" },
  { "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>",                desc = "Previous diagnostic" },
  { "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>",                desc = "Next diagnostic" },
  { "<leader>dk", "<cmd>lua vim.lsp.buf.hover()<cr>",                       desc = "Show hover info" },
  { "<leader>da", "<cmd>FzfLua lsp_code_actions<cr>",                       desc = "Show code actions" },
  { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>",                    desc = "Show diagnostics" },
  { "<leader>dD", "<cmd>Trouble lsp toggle<cr>",                            desc = "Show LSP items" },
  { "<leader>ds", "<cmd>Trouble symbols toggle<cr>",                        desc = "Show symbols" },
  { "<leader>dF", "<cmd>lua vim.lsp.buf.format { timeout_ms = 20000 }<cr>", desc = "Format buffer" },
  { "<leader>dt", "<cmd>lua toggle_diag_virtual_text()<cr>",                desc = "Toggle virtual text" }
})

wk.add({
  { "<leader>df",  group = "search" },
  { "<leader>dfa", "<cmd>FzfLua lsp_finder<cr>",                desc = "All LSP" },
  { "<leader>dfr", "<cmd>FzfLua lsp_references<cr>",            desc = "References" },
  { "<leader>dfd", "<cmd>FzfLua lsp_definitions<cr>",           desc = "Definitions" },
  { "<leader>dfD", "<cmd>FzfLua lsp_type_definitions<cr>",      desc = "Type definitions" },
  { "<leader>dfi", "<cmd>FzfLua lsp_implementations<cr>",       desc = "Implementations" },
  { "<leader>dfs", "<cmd>FzfLua lsp_document_symbols<cr>",      desc = "Document symbols" },
  { "<leader>dfS", "<cmd>FzfLua lsp_workspace_symbols<cr>",     desc = "Workspace symbols" },
  { "<leader>dfn", "<cmd>FzfLua lsp_document_diagnostics<cr>",  desc = "Document diagnostics" },
  { "<leader>dfN", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "All diagnostics" }
})

-- FZF
wk.add({
  { "<leader>f",  group = "search" },
  { "<leader>fs", plugin = "spelling",               desc = "Spellings" },
  { "<leader>ff", "<cmd>FzfLua files<cr>",           desc = "All files" },
  { "<leader>fo", "<cmd>FzfLua oldfiles<cr>",        desc = "Old files" },
  { "<leader>fq", "<cmd>FzfLua quickfix<cr>",        desc = "Quickfix list" },
  { "<leader>fb", "<cmd>FzfLua buffers<cr>",         desc = "Buffers" },
  { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",      desc = "Grep current word" },
  { "<leader>fm", "<cmd>FzfLua marks<cr>",           desc = "Marks" },
  { "<leader>fr", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
  { "<leader>fl", "<cmd>FzfLua grep_curbuf<cr>",     desc = "Grep in buffer" },
  { "<leader>fh", "<cmd>FzfLua helptags<cr>",        desc = "Helptags" },
  {
    "<leader>fp",
    "<cmd>lua require('fzf-lua').grep_project({cwd = cwd_or_git()})<cr>",
    desc = "Search project files"
  }
})

-- Spelling
wk.add({
  { "<leader>s",  group = "spelling" },
  { "<leader>ss", desc = "Toggle spell check" },
  { "<leader>sn", "]s",                       desc = "Next misspelling" },
  { "<leader>sp", "[s",                       desc = "Previous misspelling" },
  { "<leader>sa", "zg",                       desc = "Add to dictionary" },
  { "<leader>sf", plugin = "spelling",        desc = "Lookup in dictionary" },
  { "<leader>s?", plugin = "spelling",        desc = "Lookup in dictionary" }
})

-- Folding
wk.add({
  { "<leader>z",  group = "folding" },
  { "<leader>zt", "zi",             desc = "Toggle folding" },
  { "<leader>za", "za",             desc = "Toggle current" },
  { "<leader>zA", "zA",             desc = "Toggle all under cursor" },
  { "<leader>zr", "zr",             desc = "Open one level in buffer" },
  { "<leader>zR", "zR",             desc = "Open all" },
  { "<leader>zm", "zm",             desc = "Close one level in buffer" },
  { "<leader>zM", "zM",             desc = "Close all" },
  { "<leader>zi", "zi",             hidden = true }
})

-- Git
wk.add({
  { "<leader>g",  group = "git" },
  { "<leader>gb", "<cmd>lua require'gitsigns'.blame_line{}<CR>", desc = "View line blame" },
  { "<leader>gt", "<cmd>Gitsigns toggle_signs<cr>",              desc = "Toggle git signs" },
  { "<leader>gd", "<cmd>Gitsigns preview_hunk<cr>",              desc = "View diff preview" },
  { "<leader>gD", "<cmd>Gitsigns diffthis<cr>",                  desc = "View full diff" },
  { "<leader>gn", "<cmd>Gitsigns next_hunk<cr>",                 desc = "Next hunk" },
  { "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>",                 desc = "Previous hunk" },
  { "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Undo hunk" },
  { "<leader>gU", "<cmd>Gitsigns undo_stage_hunk<cr>",           desc = "Undo stage hunk" },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",                desc = "Stage hunk" },
  { "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>",                desc = "Stage hunk" },
  { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",              desc = "Stage buffer" },
  { "<leader>gh", "<cmd>Gitsigns toggle_linehl<cr>",             desc = "Toggle highlights" },
  {
    cond = get_git_exit(),
    { "<leader>gf",  group = "search" },
    { "<leader>gfc", "<cmd>FzfLua git_commits<cr>",  desc = "Commits" },
    { "<leader>gfC", "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer commits" },
    { "<leader>gfb", "<cmd>FzfLua git_branches<cr>", desc = "Branches" },
    { "<leader>gfd", "<cmd>FzfLua git_status<cr>",   desc = "Diff" },
    { "<leader>gfS", "<cmd>FzfLua git_stash<cr>",    desc = "Stash" },
    { "<leader>fg",  "<cmd>FzfLua git_files<cr>",    desc = "Git files" },
    { "<leader>fd",  "<cmd>FzfLua git_status<cr>",   desc = "Git diff" },
    { "<leader>fc",  "<cmd>FzfLua git_commits<cr>",  desc = "Git commits" },
    { "<leader>gg",  "<cmd>FzfLua git_status<cr>",   desc = "Search git changes" }
  }
})
