return {
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-dap"
    },
    ft = "python",
    config = function()
      local mason_registry = require("mason-registry")
      local debugpy_reg = mason_registry.get_package("debugpy")
      local debugpy_path = debugpy_reg:get_install_path() .. "/venv/bin/python"
      require("dap-python").setup(debugpy_path)

      -- Setup DAP specific keybinds
      local wk = require("which-key")
      wk.register({
        ["<leader>db"] = {
          "<cmd>lua require('dap').toggle_breakpoint()<cr>",
          "Rename identifier"
        }
      })
    end
  }
}
