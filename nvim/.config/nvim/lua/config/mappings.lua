local wk = require("which-key")
wk.register(mappings, opts)

-- Non-leader mappings
wk.register({
  ["<C-r>"]   = {
    "<cmd>FzfLua command_history<cr>",
    "Search command history"
  },
  ["<C-t>"]   = { "<cmd>FzfLua files<cr>"           , "Search files"         },
  ["<C-A>"]   = { "Increment up"                                             },
  ["<C-X>"]   = { "Increment down"                                           },
  ["<TAB>"]   = { "Next buffer"                                              },
  ["<S-TAB>"] = { "Previous buffer"                                          },
  ["."]       = { "Repeat last command"                                      },
  ["*"]       = { "Select current word"                                      },
  ["m"]       = { "Set mark at current line"                                 },
  ["q"]       = { "Begin recording macro"                                    },
  ["~"]       = { "Toggle current case"                                      },
  ["%"]       = { "Go to matching bracket"                                   },
  ["R"]       = { "Replace with last yank"                                   },
  ["u"]       = { "Undo"                                                     },
  ["U"]       = { "Redo"                                                     },
  [";"]       = { "Repeat last move"                                         },
  ["J"]       = { "Join lines"                                               },
  ["f"]       = { "which_key_ignore"                                         },
  ["F"]       = { "which_key_ignore"                                         },
  ["t"]       = { "which_key_ignore"                                         },
  ["T"]       = { "which_key_ignore"                                         },
  [">"]       = { "which_key_ignore"                                         },
  ["<"]       = { "which_key_ignore"                                         },
  ["&"]       = { "which_key_ignore"                                         },
  ["0"]       = { "which_key_ignore"                                         },
  ["i"]       = { "which_key_ignore"                                         },
  ["j"]       = { "which_key_ignore"                                         },
  ["Y"]       = { "which_key_ignore"                                         },
  ["`"]       = { "which_key_ignore"                                         },
  ["@"]       = { "which_key_ignore"                                         },
  ["!"]       = { "which_key_ignore"                                         },
  ["["]       = { "which_key_ignore"                                         },
  ["]"]       = { "which_key_ignore"                                         },
  ["<BS>"]    = { "which_key_ignore"                                         },
  ["<CR>"]    = { "which_key_ignore"                                         },
  ["<C-L>"]   = { "which_key_ignore"                                         },
  ["c"]       = { "which_key_ignore"                                         },
  ["d"]       = { "which_key_ignore"                                         },
  ["y"]       = { "which_key_ignore"                                         },
  ["<SNR>"]   = { "which_key_ignore"                                         },
  ["?"]       = { "Open Copilot Chat"                                        },
  ["-"]       = {
    "<cmd>lua require('oil').open_float()<cr>",
    "Open parent directory"
  }
})

wk.register({ z = { name = "+fold" } })
wk.register({
  g = {
    name = "+misc",
    c = { "which_key_ignore"                                                 },
    h = { "Toggle hidden files"                                              },
    [";"] = { "Go to last edited position"                                   },
  }
})

-- Leader mappings
wk.register({
  ["<leader>"] = {
    name = "+leader",
    L = { "<cmd>Lazy<cr>"                      , "Open Lazy"                 },
    M = { "<cmd>Mason<cr>"                     , "Open Mason"                },
    Z = { "<cmd>lua toggleZenMode()<cr>"       , "Toggle Zen mode"           },
    m = { "<cmd>lua toggleAutoCmp()<cr>"       , "Toggle completion"         },
    n = { "<cmd>setlocal wrap!<cr>"            , "Toggle word wrap"          },
    c = { "Toggle comment"                                                   },
    p = { "Paste from clipboard"                                             },
    y = { "Copy to clipboard"                                                },
    x = { "Delete buffer"                                                    },
    Q = { "Exit without saving"                                              },
    q = { "which_key_ignore"                                                 },
    j = { "which_key_ignore"                                                 },
    h = { "which_key_ignore"                                                 },
    k = { "which_key_ignore"                                                 },
    l = { "which_key_ignore"                                                 },
    w = { "which_key_ignore"                                                 },
    W = { "which_key_ignore"                                                 },
    P = { "which_key_ignore"                                                 },
    Y = { "which_key_ignore"                                                 },
    yy = { "which_key_ignore"                                                },
    ["<S-SPACE>"] = { "which_key_ignore"                                     },
    ["<SPACE>"]  = { "Toggle fold"                                           },
    ["<TAB>"]    = { "Next window"                                           },
    ["<S-TAB>"]  = { "Previous window"                                       },
    ["-"]        = { "New vertical split"                                    },
    ["_"]        = { "New horizontal split"                                  },
    ["<Tab>"]    = { "Next window"                                           },
    ["?"]        = { "Open Copilot prompts"                                  },
    ["<CR>"]     = { "Send to tmux"                                          },
    ["/"]        = {
      "<cmd>FzfLua grep_curbuf<cr>",
      "Search current buffer"
    },
    ["."]        = {
      "<cmd>lua require('oil').open_float('.')<cr>",
      "Open current directory"
    }
  }
})

wk.register({
  b = {
    name = "buffer",
    f = { "<cmd>FzfLua buffers<cr>"               , "Search buffers"         },
    b = { "New (no split)"                                                   },
    n = { "New (no split)"                                                   },
    c = { "Close"                                                            },
  }
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "lsp",
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Previous diagnostic" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<cr>"  , "Next diagnostic"     },
    k = { "<cmd>lua vim.lsp.buf.hover()<cr>"         , "Show hover info"     },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>"   , "Show code actions"   },
    d = {
      "<cmd>TroubleToggle document_diagnostics<cr>",
      "Show document diagnostics"
    },
    D = {
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      "Show workspace diagnostics"
    },
    F = {
      "<cmd>lua vim.lsp.buf.format { timeout_ms = 20000 }<cr>",
      "Format buffer"
    },
    f = {
      name = "search",
      a = { "<cmd>FzfLua lsp_finder<cr>"             , "All LSP"             },
      r = { "<cmd>FzfLua lsp_references<cr>"         , "References"          },
      d = { "<cmd>FzfLua lsp_definitions<cr>"        , "Definitions"         },
      D = { "<cmd>FzfLua lsp_type_definitions<cr>"   , "Type definitions"    },
      i = { "<cmd>FzfLua lsp_implementations<cr>"    , "Implementations"     },
      s = { "<cmd>FzfLua lsp_document_symbols<cr>"   , "Document symbols"    },
      S = { "<cmd>FzfLua lsp_workspace_symbols<cr>"  , "Workspace symbols"   },
      n = {
        "<cmd>FzfLua lsp_document_diagnostics<cr>",
        "Document diagnostics"
      },
      N = {
        "<cmd>FzfLua lsp_workspace_diagnostics<cr>",
        "All diagnostics"
      },
    },
  }
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "search",
    f = { "<cmd>FzfLua files<cr>"                     , "All files"          },
    o = { "<cmd>FzfLua oldfiles<cr>"                  , "Old files"          },
    q = { "<cmd>FzfLua quickfix<cr>"                  , "Quickfix list"      },
    b = { "<cmd>FzfLua buffers<cr>"                   , "Buffers"            },
    w = { "<cmd>FzfLua grep_cword<cr>"                , "Grep current word"  },
    m = { "<cmd>FzfLua marks<cr>"                     , "Marks"              },
    r = { "<cmd>FzfLua command_history<cr>"           , "Command history"    },
    s = { "<cmd>FzfLua spell_suggest<cr>"             , "Spellings"          },
    l = { "<cmd>FzfLua grep_curbuf<cr>"               , "Grep in buffer"     },
    h = { "<cmd>FzfLua helptags<cr>"                  , "Helptags"           },
  }
}, { prefix = "<leader>" })

wk.register({
  g = {
    name = "git",
    b = { "<cmd>lua require'gitsigns'.blame_line{}<CR>", "View line blame"   },
    t = { "<cmd>Gitsigns toggle_signs<cr>"            , "Toggle git signs"   },
    d = { "<cmd>Gitsigns preview_hunk<cr>"            , "View diff preview"  },
    D = { "<cmd>Gitsigns diffthis<cr>"                , "View full diff"     },
    n = { "<cmd>Gitsigns next_hunk<cr>"               , "Next hunk"          },
    p = { "<cmd>Gitsigns prev_hunk<cr>"               , "Previous hunk"      },
    u = { "<cmd>Gitsigns reset_hunk<cr>"              , "Undo hunk"          },
    U = { "<cmd>Gitsigns undo_stage_hunk<cr>"         , "Undo stage hunk"    },
    s = { "<cmd>Gitsigns stage_hunk<cr>"              , "Stage hunk"         },
    a = { "<cmd>Gitsigns stage_hunk<cr>"              , "Stage hunk"         },
    S = { "<cmd>Gitsigns stage_buffer<cr>"            , "Stage buffer"       },
    h = { "<cmd>Gitsigns toggle_linehl<cr>"           , "Toggle highlights"  },
  }
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "spell",
    s = { "Toggle spell check"                                               },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
    f = { "<cmd>FzfLua spell_suggest<cr>"      , "Lookup in dictionary"      },
    ["?"] = { "<cmd>FzfLua spell_suggest<cr>"  , "which_key_ignore"          },
  }
}, { prefix = "<leader>" })

wk.register({
  z = {
    name = "fold",
    t = { "zi"                            , "Toggle folding"                 },
    i = { "zi"                            , "which_key_ignore"               },
    a = { "za"                            , "Toggle current"                 },
    A = { "zA"                            , "Toggle all under cursor"        },
    r = { "zr"                            , "Open one level in buffer"       },
    R = { "zR"                            , "Open all"                       },
    m = { "zm"                            , "Close one level in buffer"      },
    M = { "zM"                            , "Close all"                      },
  }
}, { prefix = "<leader>" })

-- Helper function to check if in a git dir
get_git_exit = function()
  return os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
end

-- Map <leader><leader> to git files if available, else normal files
local fzf = require("fzf-lua")
proj_files = function()
  if get_git_exit() == 0 then
    fzf.git_files()
  else
    fzf.files()
  end
end

wk.register({
  ["<leader>"] = {
    "<cmd>lua proj_files()<cr>",
    "Search git files"
  }
}, { prefix = "<leader>" })

-- Search from CWD if not in a git dir
cwd_or_git = function()
  if get_git_exit() == 0 then
    return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  else
    return vim.loop.cwd()
  end
end

wk.register({
  f = {
    name = "search",
    p = {
      "<cmd>lua require('fzf-lua').grep_project({cwd = cwd_or_git()})<cr>",
      "Grep in project"
    }
  }
}, { prefix = "<leader>" })

-- Map git bindings if in git repo
if get_git_exit() == 0 then
  wk.register({
    g = {
      name = "git",
      g = { "<cmd>FzfLua git_status<cr>"              , "Search git changes" },
      f = {
        name = "search",
        c = { "<cmd>FzfLua git_commits<cr>"           , "Commits"            },
        C = { "<cmd>FzfLua git_bcommits<cr>"          , "Buffer commits"     },
        b = { "<cmd>FzfLua git_branches<cr>"          , "Branches"           },
        d = { "<cmd>FzfLua git_status<cr>"            , "Diff"               },
        S = { "<cmd>FzfLua git_stash<cr>"             , "Stash"              },
      }
    }
  }, { prefix = "<leader>" })

  wk.register({
    f = {
      g = { "<cmd>FzfLua git_files<cr>"               , "Git files"          },
      d = { "<cmd>FzfLua git_status<cr>"              , "Git diff"           },
      c = { "<cmd>FzfLua git_commits<cr>"             , "Git commits"        },
    }
  }, { prefix = "<leader>" })
end
