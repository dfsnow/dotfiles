if vim.g.vscode then return end

-- PackChanged hooks (must be defined BEFORE vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end
})

vim.pack.add({
  gh("nvim-treesitter/nvim-treesitter"),
})

local helpers = require("helpers")
local ts = require("nvim-treesitter")

-- Parsers that nvim-treesitter can install, loaded on first use
local available

local function start(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or helpers.is_big_file(buf) then return end
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.treesitter.start(buf, lang)
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Start treesitter by filetype",
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if vim.treesitter.language.add(lang) then
      start(args.buf, lang)
      return
    end

    -- Install a missing parser, then start treesitter when it is ready
    available = available or ts.get_available()
    if vim.tbl_contains(available, lang) then
      ts.install(lang):await(vim.schedule_wrap(function(err)
        if not err and vim.treesitter.language.add(lang) then
          start(args.buf, lang)
        end
      end))
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("treesitter_fold_workaround", {}),
  desc = "Add treesitter folding + workaround",
  callback = function(args)
    -- Skip setting foldmethod in diffview
    local ok, lib = pcall(require, "diffview.lib")
    if ok and lib.get_current_view() ~= nil then return end
    local big_file = helpers.is_big_file(args.buf)
    if not big_file then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})
