local wk = require("which-key")
wk.register(mappings, opts)

-- Non-leader mappings
wk.register({
  ["<C-r>"]   = {
    "<cmd>Telescope command_history<cr>",
    "Search command history"
  },
  ["<C-t>"]   = { "<cmd>Telescope find_files<cr>"   , "Search files"         },
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
    j = { "which_key_ignore"                                                 },
    k = { "which_key_ignore"                                                 },
    l = { "which_key_ignore"                                                 },
    w = { "which_key_ignore"                                                 },
    W = { "which_key_ignore"                                                 },
    P = { "which_key_ignore"                                                 },
    Y = { "which_key_ignore"                                                 },
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
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
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
    f = { "<cmd>Telescope buffers<cr>"         , "Search buffers"            },
    b = { "New (no split)"                                                   },
    n = { "New (no split)"                                                   },
    c = { "Close"                                                            },
  }
}, { prefix = "<leader>" })

wk.register({
  d = {
    name = "lsp",
    R = { "<cmd>lua vim.lsp.buf.rename()<cr>"        , "Rename identifer"    },
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
    f = { "<cmd>Telescope find_files<cr>"             , "All files"          },
    b = { "<cmd>Telescope buffers<cr>"                , "Buffers"            },
    w = { "<cmd>Telescope grep_string<cr>"            , "Grep current word"  },
    m = { "<cmd>Telescope marks<cr>"                  , "Marks"              },
    h = { "<cmd>Telescope command_history<cr>"        , "Command history"    },
    r = { "<cmd>Telescope live_grep<cr>"              , "Grep in project"    },
    s = { "<cmd>Telescope spell_suggest<cr>"          , "Spellings"          },
    l = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Grep in buffer"   },
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
    f = { "<cmd>Telescope spell_suggest<cr>"   , "Lookup in dictionary"      },
    ["?"] = { "<cmd>Telescope spell_suggest<cr>", "which_key_ignore"         },
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

-- Map <leader><leader> to git files if available, else find files
local utils = require("telescope.utils")
local builtin = require("telescope.builtin")
project_files = function()
    local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }) 
    if ret == 0 then 
        builtin.git_files() 
    else 
        builtin.find_files() 
    end 
end

wk.register({
  ["<leader>"] = {
    "<cmd>lua project_files()<cr>",
    "Search git files"
  }
}, { prefix = "<leader>" })

-- Map git bindings if in git repo
local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }) 
if ret == 0 then 

  wk.register({
    g = {
      name = "git",
      g = { "<cmd>Telescope git_status<cr>"           , "Search git changes" },
      f = {
        name = "search",
        c = { "<cmd>Telescope git_commits<cr>"        , "Commits"            },
        C = { "<cmd>Telescope git_bcommits<cr>"       , "Buffer commits"     },
        b = { "<cmd>Telescope git_branches<cr>"       , "Branches"           },
        d = { "<cmd>Telescope git_status<cr>"         , "Diff"               },
        S = { "<cmd>Telescope git_stash<cr>"          , "Stash"              },
      }
    }
  }, { prefix = "<leader>" })

  wk.register({
    f = {
      g = { "<cmd>Telescope git_files<cr>"            , "Git files"          },
      d = { "<cmd>Telescope git_status<cr>"           , "Git diff"           },
      c = { "<cmd>Telescope git_commits<cr>"          , "Git commits"        },
    }
  }, { prefix = "<leader>" })

end
