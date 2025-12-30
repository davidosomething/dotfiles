-- JavaScript / TypeScript stuff

local M = {}

M.fts = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

---@see https://github.com/rachartier/tiny-code-action.nvim#filters
---@param action { title: string, isPreferred: boolean }
M.filter_code_actions = function(action)
  ---Don't suggest importing from node_modules/
  if action.title:find('Add import from "node_modules/') then
    return false
  end
  return true
end

---Each item is weighted exponentially higher than the next
M.code_action_priority_list = {
  "Bump to", -- version_lsp
  "Update the dependencies",
  "Update import",
  "Add all missing imports",
  'Add import from "@',
  'Add import from "%.',
  'Add import from "',
  "Fix ",
  "for this line",
  "for the entire file",
  "Remove ",
  "Convert ",
  "Add missing function",
  "Infer function",
  "Extract to",
  "spelling",
  "Show documentation",
  "Add all missing function",
  "Add braces",
  "Generate",
  "Show documentation",
  "Move to a new file",
}

M._sort_code_actions = function(a, b)
  if type(a.action.title) ~= "string" or type(b.action.title) ~= "string" then
    return false
  end
  if a.action.title == b.action.title then
    return false
  end

  local a_priority = 0
  local b_priority = 0
  for i, substr in ipairs(M.code_action_priority_list) do
    local a_match = a.action.title:match(substr)
    local b_match = b.action.title:match(substr)
    if a_match ~= nil then
      a_priority = i
    end
    if b_match ~= nil then
      b_priority = i
    end
    if a_priority > 0 or b_priority > 0 then
      return a_priority > b_priority
    end
  end
  return false
end

---@see https://github.com/rachartier/tiny-code-action.nvim#sorting
---@return boolean
M.sort_code_actions = function(a, b)
  local ok, result = pcall(M._sort_code_actions, a, b)
  if not ok then
    return false
  end
  return result
end

return M
