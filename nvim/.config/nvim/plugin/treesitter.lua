-- PackChanged hooks (must be defined BEFORE vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == "nvim-treesitter" and kind == "update" then
    if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
    vim.cmd("TSUpdate")
  end
end })

vim.pack.add({
  gh("nvim-treesitter/nvim-treesitter"),
})

if not vim.g.vscode then
  local helpers = require("helpers")

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    desc = "Start treesitter by filetype",
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(ft)
      local big_file = helpers.is_big_file(args.buf)
      if not vim.treesitter.language.add(lang) then
          local available = vim.g.ts_available or require("nvim-treesitter").get_available()
          if not vim.g.ts_available then
            vim.g.ts_available = available
          end
          if vim.tbl_contains(available, lang) then
            require("nvim-treesitter").install(lang)
          end
      end
      if vim.treesitter.language.add(lang) and not big_file then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start(args.buf, lang)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("treesitter_fold_workaround", {}),
    desc = "Add treesitter folding + workaround",
    callback = function(args)
      local big_file = helpers.is_big_file(args.buf)
      if not big_file then
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
    end,
  })
end
