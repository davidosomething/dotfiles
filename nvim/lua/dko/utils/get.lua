---Like lodash.get
---@param tbl table
---@param path string with path.dot.delimited
---@return any value in table at that path
return function (tbl, path)
  local parts = vim.split(path, '.', { plain = true })
  return vim.tbl_get(tbl, unpack(parts))
end
