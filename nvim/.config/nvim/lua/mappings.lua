local wk = require("which-key")
wk.register(mappings, opts)

-- Non-leader mappings
wk.register({
  ["?"]       = {
    "<cmd>Telescope current_buffer_fuzzy_find<cr>",
    "Search in buffer"
  },
  ["<C-r>"]   = {
    "<cmd>Telescope command_history<cr>",
    "Search command history"
  },
  ["<C-t>"]   = { "<cmd>Telescope find_files<cr>"   , "Search files"         },
  ["K"]       = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover info"      },
  ["-"]       = { "Open parent directory"                                    },
  ["<C-A>"]   = { "Increment up"                                             },
  ["<C-X>"]   = { "Increment down"                                           },
  ["<TAB>"]   = { "Next window"                                              },
  ["<S-TAB>"] = { "Previous window"                                          },
  ["."]       = { "Repeat last command"                                      },
  ["*"]       = { "Select current word"                                      },
  ["m"]       = { "Set mark at current line"                                 },
  ["q"]       = { "Begin recording macro"                                    },
  ["~"]       = { "Toggle current case"                                      },
  ["%"]       = { "Go to matching bracket"                                   },
  ["R"]       = { "Replace with last yank"                                   },
  ["u"]       = { "Undo"                                                     },
  ["U"]       = { "Undo line"                                                },
  [">"]       = { "which_key_ignore"                                         },
  ["<"]       = { "which_key_ignore"                                         },
  ["&"]       = { "which_key_ignore"                                         },
  ["0"]       = { "which_key_ignore"                                         },
  ["i"]       = { "which_key_ignore"                                         },
  ["J"]       = { "which_key_ignore"                                         },
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
})

-- Hop mappings
local hop = require("hop")
local directions = require("hop.hint").HintDirection
wk.register({
  ["<Space>"] = { "<cmd>HopWord<cr>"                , "Hop anywhere"         },
  f = { 
    function()
      hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true
      })
    end
    , "Hop forward"
  },
  F = { 
    function()
      hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true
      })
    end
    , "Hop backward"
  },
  t = { 
    function()
      hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1
      })
    end
    , "Hop forward"
  },
  T = { 
    function()
      hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = -1
      })
    end
    , "Hop backward"
  },
}, { mode = { "n", "v", "o" } })

wk.register({
  ["<Space>"] = { "<cmd>HopLineStart<cr>"      , "Hop to line"               },
}, {
  prefix = "<leader>",
  mode = { "n", "v", "o" } 
})

wk.register({ z = { name = "+fold" } })
wk.register({
  g = {
    name = "+misc",
    c = { "which_key_ignore"                                                 }, 
    h = { "Toggle hidden files"                                              }, 
    [";"] = { "Go to last edited postition"                                  }, 
  } 
})

-- Leader mappings
wk.register({
  ["<leader>"] = {
    name = "+leader",
    x = { "<cmd>lua toggleAutoCmp()<cr>"       , "Toggle completion"         },
    n = { "<cmd>setlocal wrap!<cr>"            , "Toggle word wrap"          },
    v = { "Select with treesitter"                                           },
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
    ["ll"]       = { "Next buffer"                                           },
    ["hh"]       = { "Previous buffer"                                       },
    ["<Tab>"]    = { "Next window"                                           },
    ["."]        = { "<cmd>e .<CR>"            , "Open current directory"    },        
    ["<leader>"] = {
      "<cmd>Telescope find_files<cr>",
      "Search files"
    },
    ["?"]        = {
      "<cmd>Telescope live_grep<cr>",
      "Grep in project"
    },
    ["/"]        = {
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      "Search current buffer"
    }
  }
}) 

wk.register({
  b = {
    name = "buffer",
    f = { "<cmd>Telescope buffers<cr>"         , "Search buffers"            },
    h = { "New (horizontal)"                                                 },
    v = { "New (vertical)"                                                   },
    n = { "New (no split)"                                                   },
    c = { "Close"                                                            },
    d = { "which_key_ignore"                                                 },
    a = { "Close all"                                                        },
    ["-"] = { "which_key_ignore"                                             },
    ["_"] = { "which_key_ignore"                                             },
  }
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "lsp",
    R = { "Rename identifer"                                                 },
    p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>"  , "Previous diagnostic" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<cr>"  , "Next diagnostic"     },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>"    , "Show references"     },
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>"    , "Goto definition"     },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>"   , "Goto declaration"    },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Show implementations"},
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help" },
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>"         , "Show hover info"     },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>"   , "Show code actions"   },
    F = { 
      "<cmd>lua vim.lsp.buf.format { timeout_ms = 20000 }<cr>",
      "Format buffer"
    },
    f = {
      name = "search",
      r = { "<cmd>Telescope lsp_references<cr>"       , "References"         },
      d = { "<cmd>Telescope lsp_definitions<cr>"      , "Definitions"        },
      D = { "<cmd>Telescope lsp_type_definitions<cr>" , "Type definitions"   },
      i = { "<cmd>Telescope lsp_implementations<cr>"  , "Implementations"    },
      s = { "<cmd>Telescope lsp_document_symbols<cr>" , "Document symbols"   },
      S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols"  },
      n = {
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        "Document diagnostics"
      },
      N = {
        "<cmd>Telescope diagnostics<cr>",
        "All diagnostics"
      },
    },
  }
}, { prefix = "<leader>" })

wk.register({
  f = {
    name = "search",
    g = { "<cmd>Telescope git_files<cr>"              , "Git files"          },
    G = { "<cmd>Telescope git_status<cr>"             , "Git status"         },
    f = { "<cmd>Telescope find_files<cr>"             , "All files"          },
    b = { "<cmd>Telescope buffers<cr>"                , "Buffers"            },
    w = { "<cmd>Telescope grep_string<cr>"            , "Grep current word"  },
    m = { "<cmd>Telescope marks<cr>"                  , "Marks"              },
    h = { "<cmd>Telescope command_history<cr>"        , "Command history"    },
    c = { "<cmd>Telescope git_commits<cr>"            , "Git commits"        },
    r = { "<cmd>Telescope live_grep<cr>"              , "Grep in project"    },
    l = { "<cmd>Telescope live_grep<cr>"              , "which_key_ignore"   },
    s = { "<cmd>Telescope spell_suggest<cr>"          , "Spellings"          },
    l = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Grep in buffer"   },
  }
}, { prefix = "<leader>" })

wk.register({
  G = { "<cmd>Git<cr>"                                , "Open git"           },
  g = {
    name = "git",
    b = { "<cmd>lua require'gitsigns'.blame_line{}<CR>", "View line blame"   },
    o = { "<cmd>Git<cr>"                              , "Open git"           },
    B = { "<cmd>Git blame<cr>"                        , "View full blame"    },
    c = { "<cmd>Git commit<cr>"                       , "Create commit"      },
    g = { "<cmd>Gitsigns toggle_signs<cr>"            , "Toggle git signs"   },
    d = { "<cmd>Gitsigns preview_hunk<cr>"            , "View diff preview"  },
    D = { "<cmd>Gitsigns diffthis<cr>"                , "View full diff"     },
    P = { "<cmd>Git push<cr>"                         , "Push to remote"     },
    n = { "<cmd>Gitsigns next_hunk<cr>"               , "Next hunk"          },
    p = { "<cmd>Gitsigns prev_hunk<cr>"               , "Previous hunk"      },
    u = { "<cmd>Gitsigns reset_hunk<cr>"              , "Undo hunk"          },
    U = { "<cmd>Gitsigns undo_stage_hunk<cr>"         , "Undo stage hunk"    },
    s = { "<cmd>Gitsigns stage_hunk<cr>"              , "Stage hunk"         },
    S = { "<cmd>Gitsigns stage_buffer<cr>"            , "Stage buffer"       },
    h = { "<cmd>Gitsigns toggle_linehl<cr>"           , "Toggle highlights"  },
    v = { "<cmd>GV!<cr>"                              , "Browse file commits"},
    V = { "<cmd>GV<cr>"                               , "Browse all commits" },
    f = {
      name = "search",
      c = { "<cmd>Telescope git_commits<cr>"          , "Commits"            },
      C = { "<cmd>Telescope git_bcommits<cr>"         , "Buffer commits"     },
      b = { "<cmd>Telescope git_branches<cr>"         , "Branches"           },
      s = { "<cmd>Telescope git_status<cr>"           , "Status"             },
      S = { "<cmd>Telescope git_stash<cr>"            , "Stash"              },
    }
  }
}, { prefix = "<leader>" })

wk.register({
  gb = { "<cmd>GBrowse<cr>"                           , "View git upstream"  },
}, { mode = { "n", "v", "o" } })

wk.register({
  s = {
    name = "spell",
    s = { "Toggle spell check"                                               },
    n = { "]s"                                 , "Next misspelling"          },
    p = { "[s"                                 , "Previous misspelling"      },
    a = { "zg"                                 , "Add to dictionary"         },
    f = { "<cmd>Telescope spell_suggest<cr>"   , "Lookup in dictionary"      },
    ["?"] = { "<cmd>Telescope spell_suggest<cr>", "which_key_ignore"         },
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

