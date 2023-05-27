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
["u"]       = { "Undo"                                                       },
["U"]       = { "Undo line"                                                  },
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

wk.register({ z = { name = "+fold" } })
wk.register({
  g = {
    name = "+misc",
    c = { "which_key_ignore"                                                 }, 
[";"] = { "Go to last edited postition"                                      }, 
  } 
})

-- Leader mappings
wk.register({
  ["<leader>"] = {
    name = "+leader",
    x = { "<cmd>lua toggleAutoCmp()<cr>"       , "Toggle completion"         },
    n = { "<cmd>setlocal wrap!<cr>"            , "Toggle word wrap"          },
    c = { "Toggle comment"                                                   },
    p = { "Paste from clipboard"                                             },
    y = { "Copy to clipboard"                                                },
    h = { "which_key_ignore"                                                 },
    j = { "which_key_ignore"                                                 },
    k = { "which_key_ignore"                                                 },
    l = { "which_key_ignore"                                                 },
    q = { "which_key_ignore"                                                 },
    Q = { "which_key_ignore"                                                 },
    w = { "which_key_ignore"                                                 },
    W = { "which_key_ignore"                                                 },
    P = { "which_key_ignore"                                                 },
    Y = { "which_key_ignore"                                                 },
    Y = { "which_key_ignore"                                                 },
    yy = { "which_key_ignore"                                                },
["<Space>"] = { "za"                           , "Toggle current fold"       },
["?"]       = { "<cmd>FzfLua grep_project<cr>" , "Ripgrep files"             },
["/"]       = { "<cmd>FzfLua grep_curbuf<cr>"  , "Search current buffer"     },
["ll"]      = { "Next buffer"                                                },
["hh"]      = { "Previous buffer"                                            },
["<Tab>"]   = { "Next window"                                                },
  }
}) 

wk.register({
  b = {
    name = "buffer",
    s = { "<cmd>FzfLua buffers<cr>"            , "Search buffers"            },
    h = { "New (horizontal)"                                                 },
    v = { "New (vertical)"                                                   },
    n = { "New (no split)"                                                   },
    c = { "Close"                                                            },
    d = { "which_key_ignore"                                                 },
    a = { "Close all"                                                        },
    ["-"] = { "which_key_ignore"                                             },
    ["_"] = { "which_key_ignore"                                             },
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
    a = { "<cmd>FzfLua lsp_code_actions<cr>"         , "Show code actions"   },
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
    b = { "<cmd>lua require'gitsigns'.blame_line{}<CR>", "View line blame"   },
    o = { "<cmd>Git<cr>"                              , "Open git"           },
    B = { "<cmd>Git blame<cr>"                        , "View full blame"    },
    c = { "<cmd>Git commit<cr>"                       , "Create commit"      },
    g = { "<cmd>Gitsigns toggle_signs<cr>"            , "Toggle git signs"   },
    d = { "<cmd>Gitsigns diffthis<cr>"                , "View diff"          },
    f = { "<cmd>Gitsigns preview_hunk<cr>"            , "Preview hunk"       },
    n = { "<cmd>Gitsigns next_hunk<cr>"               , "Next hunk"          },
    p = { "<cmd>Gitsigns prev_hunk<cr>"               , "Previous hunk"      },
    u = { "<cmd>Gitsigns reset_hunk<cr>"              , "Undo hunk"          },
    U = { "<cmd>Gitsigns undo_stage_hunk<cr>"         , "Undo stage hunk"    },
    s = { "<cmd>Gitsigns stage_hunk<cr>"              , "Stage hunk"         },
    S = { "<cmd>Gitsigns stage_buffer<cr>"            , "Stage buffer"       },
    h = { "<cmd>Gitsigns toggle_linehl<cr>"           , "Toggle highlights"  },
  },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "spell",
    s = { "Toggle spell check"                                               },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
    ["?"] = { "Lookup in dictionary"                                         },
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

