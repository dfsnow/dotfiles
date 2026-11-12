-- $EDITOR for hunk inside the nvim float (see plugin/hunk.lua). hunk calls
-- it as a vi-style editor: "+<line> <file>". Open the file in the parent
-- nvim, behind the float, instead of in a nested editor
local line = tonumber((arg[1] or ""):match("^%+(%d+)$")) or 1
local file = arg[#arg]
if not (vim.env.NVIM and file) then os.exit(1) end

local chan = vim.fn.sockconnect("pipe", vim.env.NVIM, { rpc = true })
vim.rpcrequest(chan, "nvim_exec_lua", "HunkFloatEdit(...)", { file, line })
vim.fn.chanclose(chan)
