return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    ft = treesitter_ft,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = treesitter_parsers,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
          disable = is_big_file
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        }
      })

      -- Disable treesitter folding for large files
      vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Disable treesitter folding for large files",
        group = vim.api.nvim_create_augroup("BigFile", { clear = false }),
        callback = function(opts)
          if not is_big_file(_, opts.buf) then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
          end
        end
      })
    end
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    deps = {
      "nvim-treesitter/nvim-treesitter",
      "jpalardy/vim-slime"
    },
    ft = { "python", "r", "julia", "lua" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer"
          }
        }
      })
      -- Adds a buffer local mapping to send the outer container (usually a
      -- function or class definition) to a REPL using vim-slime
      vim.cmd([[nmap <buffer> <leader><cr> v;<Plug>SlimeRegionSendgv<esc>]])
    end
  }
}
