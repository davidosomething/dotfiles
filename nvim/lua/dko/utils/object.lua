local M = {}

---Like lodash.get
---@param tbl table
---@param path string with path.dot.delimited
---@return any value in table at that path
M.get = function(tbl, path)
  local parts = vim.split(path, ".", { plain = true })
  return vim.tbl_get(tbl, unpack(parts))
end

---Like lodash.set
---@param tbl table
---@param path string with path.dot.delimited
---@param value any
---@return boolean success?
M.set = function(tbl, path, value)
  local parts = vim.split(path, ".", { plain = true })
  if #parts == 0 then
    return false
  end

  local prev = tbl
  for i, key in ipairs(parts) do
    local is_last_part = i == #parts
    if is_last_part then
      prev[key] = value
    elseif type(prev) ~= "table" then
      vim.notify(
        ("Could not set deep path %s at %s"):format(path, key),
        vim.log.levels.ERROR
      )
      return false
    end

    prev = prev[key]
  end
  return true
end

return M
