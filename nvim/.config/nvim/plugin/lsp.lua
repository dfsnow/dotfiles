vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

if not vim.g.vscode then
  local fzf_lua = require("fzf-lua")
  local wk = require("which-key")
  local helpers = require("helpers")

  require("mason").setup({
    ui = {
      border = "single",
      backdrop = 100,
      keymaps = {
        toggle_help = "?"
      }
    }
  })

  require("mason-lspconfig").setup({ automatic_enable = false })
  require("mason-tool-installer").setup({
    run_on_start = false,
    ensure_installed = {
      "bashls",
      "cssls",
      "dockerls",
      "docker_compose_language_service",
      "eslint-lsp",
      "html",
      "lua_ls",
      "pyrefly",
      "terraform-ls",
      "ruff",
      "rust_analyzer",
      "typescript-language-server",
      "yamlls"
    }
  })

  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "single" }
  })

  -- blink.cmp language server capabilities, applied to every server
  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities()
  })

  -- Per-server overrides
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

  vim.lsp.enable({
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
    "yamlls",
    "r_language_server"
  })

  -- Disable hover from ruff: https://docs.astral.sh/ruff/editors/setup/#neovim
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    desc = "LSP: Disable hover capability from Ruff",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.name == "ruff" then
        -- Disable hover in favor of Pyrefly
        client.server_capabilities.hoverProvider = false
      end
    end
  })

  -- LSP
  wk.add({
    { "<leader>M",  "<cmd>Mason<cr>",                                                        desc = "Open Mason" },
    { "<leader>d",  group = "lsp" },
    { "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end,        desc = "Previous diagnostic" },
    { "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end,         desc = "Next diagnostic" },
    { "<leader>dk", function() vim.lsp.buf.hover({ border = "single" }) end,                 desc = "Show hover info" },
    { "<leader>da", fzf_lua.lsp_code_actions,                                                desc = "Show code actions" },
    { "<leader>dr", vim.lsp.buf.rename,                                                      desc = "Rename symbol" },
    { "<leader>dd", fzf_lua.lsp_document_diagnostics,                                        desc = "Buffer diagnostics" },
    { "<leader>dD", fzf_lua.lsp_workspace_diagnostics,                                       desc = "Workspace diagnostics" },
    { "<leader>ds", fzf_lua.lsp_document_symbols,                                            desc = "Document symbols" },
    { "<leader>dF", function() vim.lsp.buf.format({ async = true, timeout_ms = 20000 }) end, desc = "Format buffer" },
    { "<leader>dt", helpers.toggle_buffer_diagnostics,                                       desc = "Toggle diagnostics" }
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
end
