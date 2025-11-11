-- JavaScript / Typescript stuff

local M = {}

M.fts = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

---@see https://github.com/rachartier/tiny-code-action.nvim#sorting
---@return boolean
M.sort_code_actions = function(a, b)
  -- local DISABLE = "Disable "
  -- local DISABLE_PRIORITY = 100

  local SCOPED_IMPORT = 'Add import from "@'
  local SCOPED_IMPORT_PRIORITY = 10

  local a_priority = 0
  local b_priority = 0

  -- Prioritize scoped imports actions
  local a_is_scoped_import = string.match(a.action.title, SCOPED_IMPORT) ~= nil
  local b_is_scoped_import = string.match(b.action.title, SCOPED_IMPORT) ~= nil
  if a_is_scoped_import and not b_is_scoped_import then
    a_priority = a_priority - SCOPED_IMPORT_PRIORITY
  elseif not a_is_scoped_import and b_is_scoped_import then
    b_priority = b_priority - SCOPED_IMPORT_PRIORITY
  elseif a_is_scoped_import and b_is_scoped_import then
    if a.action.title:len() > b.action.title:len() then
      a_priority = a_priority + 1
    else
      a_priority = a_priority - 1
    end
  end

  -- 1 is higher priority than 2
  return a_priority < b_priority
end

return M
