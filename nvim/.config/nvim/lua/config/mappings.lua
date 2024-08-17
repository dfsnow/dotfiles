local fzf_lua = require("fzf-lua")
local gitsigns = require("gitsigns")
local lazy = require("lazy")
local oil = require("oil")
local trouble = require("trouble")
local wk = require("which-key")

local helpers = require("config.helpers")

-- Non-leader
wk.add({
  { "g",       group = "misc" },
  { "z",       group = "folding" },
  { "-",       function() oil.open_float() end,    desc = "Open parent directory" },
  { "<c-r>",   fzf_lua.command_history,            desc = "Search command history" },
  { "<c-t>",   fzf_lua.files,                      desc = "Search files" },
  { "<m-c>",   helpers.fzf_dirs,                   desc = "Search dirs" },
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
  { "<leader>L",         lazy.home,                                                    desc = "Open Lazy" },
  { "<leader>m",         helpers.toggle_cmp,                                           desc = "Toggle completion" },
  { "<leader>n",         "<cmd>setlocal wrap!<cr>",                                    desc = "Toggle word wrap" },
  { "<leader>Z",         helpers.toggle_zen_mode,                                      desc = "Toggle Zen mode" },
  { "<leader>/",         fzf_lua.grep_curbuf,                                          desc = "Search current buffer" },
  { "<leader><leader>",  function() fzf_lua.files({ cwd = helpers.cwd_or_git() }) end, desc = "Search project files" },
  { "<leader>.",         function() oil.open_float(".") end,                           desc = "Open working directory" },
  { "<leader>Q",         desc = "Exit without saving" },
  { "<leader>x",         desc = "Delete buffer" },
  { "<leader>M",         desc = "Open Mason" },
  { "<leader><space>",   desc = "Flash treesitter" },
  { "<leader><s-space>", desc = "Toggle Flash search" },
  { "<leader>-",         desc = "New vertical split" },
  { "<leader>_",         desc = "New horizontal split" },
  { "<leader><tab>",     desc = "Next window" },
  { "<leader><s-tab>",   desc = "Previous window" },
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
  },
  {
    { "<leader><cr>", helpers.smart_send, desc = "Send to tmux" },
    silent = true, noremap = true
  }
})

-- Buffer
wk.add({
  { "<leader>b",  group = "buffer" },
  { "<leader>bv", "<cmd>vnew<cr>",        desc = "New vertical split" },
  { "<leader>bh", "<cmd>new<cr>",         desc = "New horizontal split" },
  { "<leader>bf", fzf_lua.buffers,        desc = "Search buffers" },
  { "<leader>bb", desc = "New (no split)" },
  { "<leader>bn", desc = "New (no split)" },
  { "<leader>bc", desc = "Close" }
})

-- LSP
wk.add({
  { "<leader>d",  group = "lsp" },
  { "<leader>dp", vim.diagnostic.goto_prev,                                  desc = "Previous diagnostic" },
  { "<leader>dn", vim.diagnostic.goto_next,                                  desc = "Next diagnostic" },
  { "<leader>dk", vim.lsp.buf.hover,                                         desc = "Show hover info" },
  { "<leader>da", fzf_lua.lsp_code_actions,                                  desc = "Show code actions" },
  { "<leader>dd", function() trouble.toggle("diagnostics") end,              desc = "Show diagnostics" },
  { "<leader>dD", function() trouble.toggle("lsp") end,                      desc = "Show LSP items" },
  { "<leader>ds", function() trouble.toggle("symbols") end,                  desc = "Show symbols" },
  { "<leader>dF", function() vim.lsp.buf.format({ timeout_ms = 20000 }) end, desc = "Format buffer" },
  { "<leader>dt", helpers.toggle_diag_virtual_text,                          desc = "Toggle virtual text" }
})

wk.add({
  { "<leader>df",  group = "search" },
  { "<leader>dfa", fzf_lua.lsp_finder,                desc = "All LSP" },
  { "<leader>dfr", fzf_lua.lsp_references,            desc = "References" },
  { "<leader>dfd", fzf_lua.lsp_definitions,           desc = "Definitions" },
  { "<leader>dfD", fzf_lua.lsp_type_definitions,      desc = "Type definitions" },
  { "<leader>dfi", fzf_lua.lsp_implementations,       desc = "Implementations" },
  { "<leader>dfs", fzf_lua.lsp_document_symbols,      desc = "Document symbols" },
  { "<leader>dfS", fzf_lua.lsp_workspace_symbols,     desc = "Workspace symbols" },
  { "<leader>dfn", fzf_lua.lsp_document_diagnostics,  desc = "Document diagnostics" },
  { "<leader>dfN", fzf_lua.lsp_workspace_diagnostics, desc = "All diagnostics" }
})

-- FZF
wk.add({
  { "<leader>f",  group = "search" },
  { "<leader>fs", plugin = "spelling",     desc = "Spellings" },
  { "<leader>ff", fzf_lua.files,           desc = "All files" },
  { "<leader>fo", fzf_lua.oldfiles,        desc = "Old files" },
  { "<leader>fq", fzf_lua.quickfix,        desc = "Quickfix list" },
  { "<leader>fb", fzf_lua.buffers,         desc = "Buffers" },
  { "<leader>fw", fzf_lua.grep_cword,      desc = "Grep current word" },
  { "<leader>fm", fzf_lua.marks,           desc = "Marks" },
  { "<leader>fr", fzf_lua.command_history, desc = "Command history" },
  { "<leader>fl", fzf_lua.grep_curbuf,     desc = "Grep in buffer" },
  { "<leader>fh", fzf_lua.helptags,        desc = "Helptags" },
  {
    "<leader>fp",
    function() fzf_lua.grep_project({ cwd = helpers.cwd_or_git() }) end,
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
  { "<leader>gb", gitsigns.blame_line,      desc = "View line blame" },
  { "<leader>gt", gitsigns.toggle_signs,    desc = "Toggle git signs" },
  { "<leader>gd", gitsigns.preview_hunk,    desc = "View diff preview" },
  { "<leader>gD", gitsigns.diffthis,        desc = "View full diff" },
  { "<leader>gn", gitsigns.next_hunk,       desc = "Next hunk" },
  { "<leader>gp", gitsigns.prev_hunk,       desc = "Previous hunk" },
  { "<leader>gu", gitsigns.reset_hunk,      desc = "Undo hunk" },
  { "<leader>gU", gitsigns.undo_stage_hunk, desc = "Undo stage hunk" },
  { "<leader>gs", gitsigns.stage_hunk,      desc = "Stage hunk" },
  { "<leader>ga", gitsigns.stage_hunk,      desc = "Stage hunk" },
  { "<leader>gS", gitsigns.stage_buffer,    desc = "Stage buffer" },
  { "<leader>gh", gitsigns.toggle_linehl,   desc = "Toggle highlights" },
  {
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
  }
})

-- Proper indentation on empty lines
vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- No yanking empty lines
vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })

-- Better, space-aware line joins
vim.keymap.set({ "n", "v" }, "J", function()
  vim.cmd("normal! mzJ")
  local col = vim.fn.col(".")
  local context = string.sub(vim.fn.getline("."), col - 1, col + 1)
  if context == ") ." or context == ") :" or context:match("%( .") or context:match(". ,") or context:match("%w %.") then
    vim.cmd("undojoin | normal! x")
  elseif context == ",)" then
    vim.cmd("undojoin | normal! hx")
  end
  vim.cmd("normal! `z")
end)
