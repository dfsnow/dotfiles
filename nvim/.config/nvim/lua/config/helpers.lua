-- Hide eol and space characters
vim.b.zen_toggle_flag = false
function _G.toggle_zen_mode()
  local next_zen_toggle_flag = not vim.b.zen_toggle_flag
  local next_fold_flag = false
  if next_zen_toggle_flag then
    print("Zen mode on")
    vim.opt_local.list = false
    require("ibl").setup_buffer(0, { enabled = false })

    local original_fold_flag = vim.opt_local.foldenable:get()
    if original_fold_flag then
      next_fold_flag = original_fold_flag
      vim.opt_local.foldenable = false
    end
    require("cmp").setup({
      completion = {
        autocomplete = false
      }
    })
  else
    print("Zen mode off")
    vim.opt_local.list = true
    require("ibl").setup_buffer(0, { enabled = true })
    if next_fold_flag then
      vim.opt_local.foldenable = true
    end
    require("cmp").setup({
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
      }
    })
  end
  vim.b.zen_toggle_flag = next_zen_toggle_flag
end

-- Toggle autocompletion
vim.g.cmp_toggle_flag = true
function _G.toggle_cmp()
  local cmp = require("cmp")
  local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
  if next_cmp_toggle_flag then
    print("Completion on")
  else
    print("Completion off")
  end
  if next_cmp_toggle_flag then
    cmp.setup({
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged }
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
    vim.g.cmp_toggle_flag = next_cmp_toggle_flag
  end
end

-- Toggle virtual text from diagnostics
vim.g.show_diag_virtual_text = true
function _G.toggle_diag_virtual_text()
  local next_diag_virtual_text = not vim.g.show_diag_virtual_text
  if next_diag_virtual_text then
    print("Diagnostic virtual text on")
  else
    print("Diagnostic virtual text off")
  end
  vim.diagnostic.config({ virtual_text = next_diag_virtual_text })
  vim.g.show_diag_virtual_text = next_diag_virtual_text
end

-- Check if the buffer is absolutely huge then use it to toggle off
-- heavy features (LSP, treesitter, etc.)
_G.is_big_file = function(_, buf)
  local max_lines = 2000
  local max_filesize = 1024 * 1024 * 3
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and (vim.api.nvim_buf_line_count(buf) > max_lines
        or stats.size > max_filesize) then
    return true
  end
end

-- Helper function to check if in a git dir
_G.get_git_exit = function()
  return os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
end

-- Search from CWD if not in a git dir
_G.cwd_or_git = function()
  if get_git_exit() == 0 then
    return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  else
    return vim.loop.cwd()
  end
end

-- Get window size/position for most floating windows
_G.get_float_size = function(w_pct, h_pct)
  local w = math.ceil(vim.o.columns * w_pct)
  local h = math.ceil(vim.o.lines * h_pct)
  local c = math.floor((vim.o.columns - w) / 2 - 1)
  local r = math.floor((vim.o.lines - h) / 2 - 1)
  return w, h, c, r
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
vim.keymap.set({ "n", "v" }, "J", function()
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
