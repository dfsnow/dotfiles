return {
  "tpope/vim-sleuth",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  {
    "tpope/vim-commentary",
    config = function()
      vim.cmd([[nmap <leader>c :Commentary<cr>]])
      vim.cmd([[vmap <leader>c :Commentary<cr>gv]])
    end
  }
}
