return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "vim", "vimdoc", "query",
          "rust", "c", "cpp", "go",
          "r", "python", "julia",
          "javascript", "html", "typescript",
          "toml", "yaml", "json", "terraform",
          "bash", "awk", "jq",
          "markdown", "markdown_inline",
          "gitcommit", "gitignore", "gitattributes",
          "dockerfile", "sql", "comment"
        },
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" }
        },
        ident = { enable = true }, 
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>v",
            node_incremental = "<leader><CR>",
            node_decremental = "<leader><BS>"
          }
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        }
      })

      --Replace indent folding with treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end
  }
}
