local cmp = require("cmp")
local chat = require("CopilotChat")
local Source = {}

-- Override the default context descriptions (they aren't useful)
local context_description = {
  buffer = "Include current buffer",
  buffers = "Include all open buffers",
  file = "Include contents of provided file.\nRequires a filename",
  files = [[
  Include all non-hidden files.
  :list (default) Only includes file names
  :full Includes file contents
  ]],
  git = [[
  Include git diff.
  :unstaged (default) Include unstaged changes
  :staged Include only staged changes
  ]],
  url = "Include URL content in context.\nRequires URL input",
  register = "Include register contents.\nDefault is `+` (clipboard)"
}

--- Modified completion items that doesn"t load agents/models (increases speed)
--- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/1fe19d1fdbf9edcda8bad9b7b2d5e11aa95c1672/lua/CopilotChat/init.lua#L494
---@param callback function(table)
local function complete_items(callback)
  local prompts_to_use = chat.prompts()
  local items = {}

  for name, prompt in pairs(prompts_to_use) do
    local kind = ""
    local info = ""
    if prompt.prompt then
      kind = "user"
      info = prompt.prompt
    elseif prompt.system_prompt then
      kind = "system"
      info = prompt.system_prompt
    end

    items[#items + 1] = {
      word = "/" .. name,
      kind = kind,
      info = info,
      menu = prompt.description or "",
      icase = 1,
      dup = 0,
      empty = 0,
    }
  end

  for name, value in pairs(chat.config.contexts) do
    local additional_info = context_description[name] or ""
    items[#items + 1] = {
      word = "#" .. name,
      kind = "context",
      menu = (additional_info ~= "" and additional_info or value.description or ""),
      icase = 1,
      dup = 0,
      empty = 0,
    }
  end

  table.sort(items, function(a, b)
    if a.kind == b.kind then
      return a.word < b.word
    end
    return a.kind < b.kind
  end)

  callback(items)
end

function Source:get_trigger_characters()
  return chat.complete_info().triggers
end

function Source:get_keyword_pattern()
  return chat.complete_info().pattern
end

function Source:complete(params, callback)
  complete_items(function(items)
    items = vim.tbl_map(function(item)
      return {
        label = item.word,
        kind = cmp.lsp.CompletionItemKind.Keyword,
        documentation = {
          kind = "markdown",
          value = (item.menu ~= "" and item.menu or item.info or "")
        },
      }
    end, items)

    local prefix = string.lower(params.context.cursor_before_line:sub(params.offset))

    callback({
      items = vim.tbl_filter(function(item)
        return vim.startswith(item.label:lower(), prefix:lower())
      end, items),
    })
  end)
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function Source:execute(completion_item, callback)
  callback(completion_item)
  vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
end

local M = {}

--- Setup the nvim-cmp source for copilot-chat window
function M.setup()
  cmp.register_source("copilot-chat", Source)
  cmp.setup.filetype("copilot-chat", {
    sources = {
      { name = "copilot-chat" },
    },
  })
end

return M
