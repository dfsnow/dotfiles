if vim.g.vscode then return end

vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

local fzf_lua = require("fzf-lua")
local wk = require("which-key")
local helpers = require("helpers")

-- Language servers to install and enable, by nvim-lspconfig name
local servers = {
  "bashls",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  "eslint",
  "html",
  "lua_ls",
  "pyrefly",
  "ruff",
  "rust_analyzer",
  "terraformls",
  "ts_ls",
  "yamlls"
}

-- Linters for plugin/lint.lua, by Mason package name
local linters = {
  "actionlint",
  "hadolint",
  "markdownlint-cli2",
  "tflint",
  "yamllint"
}

require("mason").setup({
  ui = {
    backdrop = 100,
    keymaps = {
      toggle_help = "?"
    }
  }
})

require("mason-lspconfig").setup({ automatic_enable = false })
-- mason-tool-installer converts lspconfig names to Mason package names
require("mason-tool-installer").setup({
  run_on_start = false,
  ensure_installed = vim.list_extend(vim.list_extend({}, servers), linters)
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
    end
  }
})

-- Per-server overrides
-- blink.cmp adds its capabilities to every server itself
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME } },
      telemetry = { enable = false }
    }
  }
})

vim.lsp.config("yamlls", {
  filetypes = {
    "yaml",
    "yaml.docker-compose",
    "yaml.ghaction",
    "yaml.gitlab",
    "yaml.helm-values",
  }
})

-- Disable hover from ruff in favor of Pyrefly
-- https://docs.astral.sh/ruff/editors/setup/#neovim
vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

-- Disable buggy semantic tokens for terraform
vim.lsp.config("terraformls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end,
})

-- r_language_server is installed with R, not Mason
vim.lsp.enable(vim.list_extend({ "r_language_server" }, servers))

-- LSP
-- K uses the Neovim default: LSP hover when a server is attached
wk.add({
  { "K",          desc = "Show hover info" },
  { "<leader>M",  "<cmd>Mason<cr>",                                  desc = "Open Mason" },
  { "<leader>d",  group = "lsp" },
  { "<leader>dp", function() vim.diagnostic.jump({ count = -1 }) end, desc = "Previous diagnostic" },
  { "<leader>dn", function() vim.diagnostic.jump({ count = 1 }) end,  desc = "Next diagnostic" },
  { "<leader>dk", vim.lsp.buf.hover,                                 desc = "Show hover info" },
  { "<leader>da", fzf_lua.lsp_code_actions,                          desc = "Show code actions" },
  { "<leader>dr", vim.lsp.buf.rename,                                desc = "Rename symbol" },
  { "<leader>dd", fzf_lua.lsp_document_diagnostics,                  desc = "Buffer diagnostics" },
  { "<leader>dD", fzf_lua.lsp_workspace_diagnostics,                 desc = "Workspace diagnostics" },
  { "<leader>ds", fzf_lua.lsp_document_symbols,                      desc = "Document symbols" },
  { "<leader>dF", function() vim.lsp.buf.format({ async = true }) end, desc = "Format buffer" },
  { "<leader>dt", helpers.toggle_buffer_diagnostics,                 desc = "Toggle diagnostics" }
})

wk.add({
  { "<leader>df",  group = "search" },
  { "<leader>dfr", fzf_lua.lsp_references,            desc = "References" },
  { "<leader>dfd", fzf_lua.lsp_definitions,           desc = "Definitions" },
  { "<leader>dfD", fzf_lua.lsp_declarations,          desc = "Declarations" },
  { "<leader>dft", fzf_lua.lsp_typedefs,              desc = "Type definitions" },
  { "<leader>dfi", fzf_lua.lsp_implementations,       desc = "Implementations" },
  { "<leader>dfs", fzf_lua.lsp_document_symbols,      desc = "Document symbols" },
  { "<leader>dfS", fzf_lua.lsp_workspace_symbols,     desc = "Workspace symbols" },
  { "<leader>dfn", fzf_lua.lsp_document_diagnostics,  desc = "Document diagnostics" },
  { "<leader>dfN", fzf_lua.lsp_workspace_diagnostics, desc = "All diagnostics" }
})

-- Setup ruff format and fix for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  desc = "Enable ruff format and fix",
  group = vim.api.nvim_create_augroup("lsp_ruff_python", { clear = true }),
  callback = function(args)
    wk.add({
      {
        "<leader>dF",
        function()
          vim.lsp.buf.code_action({
            context = { only = { "source.fixAll" }, diagnostics = {} },
            apply = true
          })
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" }, diagnostics = {} },
            apply = true
          })
          vim.lsp.buf.format({ async = true })
        end,
        desc = "Format with ruff",
        buffer = args.buf
      }
    })
  end
})
