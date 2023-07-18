-- Hide eol and space characters
vim.g.zen_toggle_flag = false
function toggleZenMode()
  local next_zen_toggle_flag = not vim.g.zen_toggle_flag
  if next_zen_toggle_flag then
    print("Zen mode on")
  else
    print("Zen mode off")
  end
  if next_zen_toggle_flag then
    vim.cmd("IndentBlanklineDisable")
    vim.opt.list = false
    vim.opt.foldenable = false
    vim.g.zen_toggle_flag = next_zen_toggle_flag
  else
    vim.cmd("IndentBlanklineEnable")
    vim.opt.list = true
    vim.opt.foldenable = true
    vim.g.zen_toggle_flag = next_zen_toggle_flag
  end
end

-- Proper indentation on empty lines
vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- No yanking empty lines
vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })

-- Better, space-aware line joins
vim.keymap.set("n", "J", function()
  vim.cmd("normal! mzJ")
  local col = vim.fn.col(".")
  local context = string.sub(vim.fn.getline("."), col - 1, col + 1)
  if context == ") ." or context == ") :" or context:match("%( .") or context:match(". ,") or context:match("%w %.") then
    vim.cmd("undojoin | normal! x")
  elseif context == ",)" then
    vim.cmd("undojoin | normal! hx")
  end
  vim.cmd("normal! `z")
end)
