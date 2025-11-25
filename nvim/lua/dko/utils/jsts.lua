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
  "Update import",
  "Add all missing imports",
  'Add import from "@',
  'Add import from "%.',
  "Fix this prettier",
  "Fix all",
  "for this line",
  "for the entire file",
  "Remove braces",
  "Remove unused",
  "Convert parameters",
  "Convert to anonymous",
  "Add missing function",
  "Infer function",
  "Extract to",
  "Change spelling",
  "Fix all detected spelling errors",
  "Show documentation",
  "Add all missing function",
  "Add braces",
  "Generate",
  "Show documentation",
  "Move to a new file",
}

---@see https://github.com/rachartier/tiny-code-action.nvim#sorting
---@return boolean
M.sort_code_actions = function(a, b)
  local a_priority = 0
  local b_priority = 0
  for weight, substr in ipairs(M.code_action_priority_list) do
    local a_match = string.match(a.action.title, substr)
    local b_match = string.match(b.action.title, substr)
    if a_match ~= nil then
      a_priority = a_priority + math.pow(10, weight)
    end
    if b_match ~= nil then
      b_priority = b_priority + math.pow(10, weight)
    end
    if a_match and b_match then
      if a.action.title:len() > b.action.title:len() then
        a_priority = a_priority + 1
      else
        b_priority = b_priority + 1
      end
    end
  end
  return a_priority < b_priority
end

return M
