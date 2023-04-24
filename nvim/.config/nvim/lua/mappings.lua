local wk = require("which-key")
wk.register(mappings, opts)

-- Non-leader mappings
wk.register({
["K"]       = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover info"        },
["<Space>"] = { "<cmd>HopWord<cr>"                , "Hop anywhere"           },
["?"]       = { "<cmd>FzfLua grep_curbuf<cr>"     , "Search in buffer"       },
["<C-t>"]   = { "<cmd>FzfLua files<cr>"           , "Search files"           },
["<C-r>"]   = { "<cmd>FzfLua command_history<cr>" , "Search command history" },
["<C-A>"]   = { "Increment up"                                               },
["<C-X>"]   = { "Increment down"                                             },
["<TAB>"]   = { "Next window"                                                },
["<S-TAB>"] = { "Previous window"                                            },
["."]       = { "Repeat last command"                                        },
["*"]       = { "Select current word"                                        },
["m"]       = { "Set mark at current line"                                   },
["q"]       = { "Begin recording macro"                                      },
["~"]       = { "Toggle current case"                                        },
["%"]       = { "Go to matching bracket"                                     },
["R"]       = { "Replace with last yank"                                     },
[">"]       = { "which_key_ignore"                                           },
["<"]       = { "which_key_ignore"                                           },
["&"]       = { "which_key_ignore"                                           },
["0"]       = { "which_key_ignore"                                           },
["i"]       = { "which_key_ignore"                                           },
["J"]       = { "which_key_ignore"                                           },
["j"]       = { "which_key_ignore"                                           },
["Y"]       = { "which_key_ignore"                                           },
["`"]       = { "which_key_ignore"                                           },
["@"]       = { "which_key_ignore"                                           },
["!"]       = { "which_key_ignore"                                           },
["["]       = { "which_key_ignore"                                           },
["]"]       = { "which_key_ignore"                                           },
["<BS>"]    = { "which_key_ignore"                                           },
["<CR>"]    = { "which_key_ignore"                                           },
["<C-L>"]   = { "which_key_ignore"                                           },
["c"]       = { "which_key_ignore"                                           },
["d"]       = { "which_key_ignore"                                           },
["y"]       = { "which_key_ignore"                                           },
["<SNR>"]   = { "which_key_ignore"                                           },
})

wk.register({ g = { name = "+misc", c = { "which_key_ignore" } } })
wk.register({ z = { name = "+fold" } })

-- Leader mappings
wk.register({
  ["<leader>"] = {
    name = "+leader",
    x = { "<cmd>lua toggleAutoCmp()<cr>"       , "Toggle completion"         },
    c = { "<cmd>Commentary<cr>"                , "Toggle comment"            },
    n = { "<cmd>setlocal wrap!<cr>"            , "Toggle word wrap"          },
    h = { "<C-W><C-H>"                         , "which_key_ignore"          },
    j = { "<C-W><C-J>"                         , "which_key_ignore"          },
    k = { "<C-W><C-K>"                         , "which_key_ignore"          },
    l = { "<C-W><C-L>"                         , "which_key_ignore"          },
    q = { "<cmd>q<cr>"                         , "which_key_ignore"          },
    Q = { "<cmd>q!<cr>"                        , "which_key_ignore"          },
    w = { "<cmd>w!<cr>"                        , "which_key_ignore"          },
    W = { "<cmd>x<cr>"                         , "which_key_ignore"          },
    p = { '"+p'                                , "Paste from clipboard"      },
    P = { '"+P'                                , "which_key_ignore"          },
    y = { '"+y'                                , "Copy to clipboard"         },
    Y = { '"+yg_'                              , "which_key_ignore"          },
    Y = { '"+yg_'                              , "which_key_ignore"          },
    yy = { '"+yy'                              , "which_key_ignore"          },
["?"]       = { "<cmd>FzfLua grep_project<cr>" , "Ripgrep files"             },
["/"]       = { "<cmd>FzfLua grep_curbuf<cr>"  , "Search current buffer"     },
["ll"]      = { "<cmd>bnext<cr>"               , "Next buffer"               },
["hh"]      = { "<cmd>bprevious<cr>"           , "Previous buffer"           },
["<Tab>"]   = { "<C-W>w"                       , "Next window"               },
["<Space>"] = { "za"                           , "Toggle current fold"       },
  }
}) 

wk.register({
  b = {
    name = "buffer",
    ["-"] = { "<cmd>new<cr>"                   , "which_key_ignore"          },
    ["_"] = { "<cmd>vnew<cr>"                  , "which_key_ignore"          },
    h = { "<cmd>new<cr>"                       , "New (horizontal)"          },
    v = { "<cmd>vnew<cr>"                      , "New (vertical)"            },
    n = { "<cmd>enew<cr>"                      , "New (no split)"            },
    c = { "<cmd>Bclose<cr>"                    , "Close"                     },
    d = { "<cmd>Bclose<cr>"                    , "which_key_ignore"          },
    a = { "<cmd>bufdo bd<cr>"                  , "Close all"                 },
    s = { "<cmd>FzfLua buffers<cr>"            , "Search buffers"            },
  },
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "lsp",
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Previous diagnostic" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<cr>"  , "Next diagnostic"     },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>"    , "Show references"     },
    R = { "<cmd>lua vim.lsp.buf.rename()<cr>"        , "Rename references"   },
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>"    , "Goto definition"     },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>"   , "Goto declaration"    },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Show implementations"},
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help" },
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>"         , "Show hover info"     },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>"   , "Show code actions"   },
    f = { 
      "<cmd>lua vim.lsp.buf.format { timeout_ms = 20000 }<cr>",
      "Format buffer"
    },
    s = {
      name = "search",
      r = { "<cmd>FzfLua lsp_references<cr>"          , "References"         },
      d = { "<cmd>FzfLua lsp_definitions<cr>"         , "Definitions"        },
      D = { "<cmd>FzfLua lsp_declarations<cr>"        , "Declarations"       },
      i = { "<cmd>FzfLua lsp_implementations<cr>"     , "Implementations"    },
      s = { "<cmd>FzfLua lsp_document_symbols<cr>"    , "Document symbols"   },
      S = { "<cmd>FzfLua lsp_workspace_symbols<cr>"   , "Workspace symbols"  },
      n = {
        "<cmd>FzfLua lsp_document_diagnostics<cr>",
        "Document diagnostics"
      },
    },
  },
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "search",
    g = { "<cmd>FzfLua git_files<cr>"                 , "Git files"          },
    f = { "<cmd>FzfLua files<cr>"                     , "All files"          },
    b = { "<cmd>FzfLua buffers<cr>"                   , "Buffers"            },
    l = { "<cmd>FzfLua grep_curbuf<cr>"               , "Current buffer"     },
    m = { "<cmd>FzfLua marks<cr>"                     , "Marks"              },
    h = { "<cmd>FzfLua command_history<cr>"           , "History"            },
    c = { "<cmd>FzfLua git_commits<cr>"               , "Commits"            },
    r = { "<cmd>FzfLua grep_project<cr>"              , "Ripgrep files"      },
    a = { "<cmd>FzfLua grep_project<cr>"              , "which_key_ignore"   },
    d = { "<cmd>FzfLua lsp_finder<cr>"                , "LSP options"        },
    s = { "<cmd>FzfLua spell_suggest<cr>"             , "Spellings"          },
  },
}, { prefix = "<leader>" })

wk.register({
  g = {
    name = "git",
    o = { "<cmd>Git<cr>"                       , "Open git"                  },
    b = { "<cmd>Git blame<cr>"                 , "View blame"                },
    c = { "<cmd>Git commit<cr>"                , "Create commit"             },
    g = { "<cmd>GitGutterToggle<cr>"           , "Toggle git signs"          },
    d = { "<cmd>GitGutterDiff<cr>"             , "View diff"                 },
    f = { "<cmd>GitGutterFold<cr>"             , "View modified lines"       },
    n = { "<Plug>(GitGutterNextHunk)"          , "Next hunk"                 },
    p = { "<Plug>(GitGutterPrevHunk)"          , "Previous hunk"             },
    u = { "<Plug>(GitGutterUndoHunk)"          , "Undo hunk"                 },
    s = { "<Plug>(GitGutterStageHunk)"         , "Stage hunk"                },
    h = { "<cmd>GitGutterLineHighlightsToggle<cr>", "Toggle line highlights" },
  },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "spell",
    s = { "<cmd>setlocal spell!<cr>"           , "Toggle spell check"        },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
["?"] = { "<cmd>FzfLua spell_suggest<cr>"      , "Search in dictionary"      },
  }
}, { prefix = "<leader>" })

wk.register({
  t = {
    name = "term",
    t = { "<cmd>ToggleTerm<cr>"                     , "Toggle current"       },
    v = { "<cmd>ToggleTerm direction=vertical<cr>"  , "New (vertical)"       },
    h = { "<cmd>ToggleTerm direction=horizontal<cr>", "New (horizontal)"     },
    f = { "<cmd>ToggleTerm direction=float<cr>"     , "New (float)"          },
    a = { "<cmd>ToggleTermToggleAll<cr>"            , "Toggle all"           },
}}, { prefix = "<leader>" })

wk.register({
  z = {
    name = "fold",
    a = { "za"                            , "Toggle current"                 },
    A = { "zA"                            , "Toggle all under cursor"        },
    r = { "zr"                            , "Open one level in buffer"       },
    R = { "zR"                            , "Open all"                       },
    m = { "zm"                            , "Close one level in buffer"      },
    M = { "zM"                            , "Close all"                      },
  },
}, { prefix = "<leader>" })

