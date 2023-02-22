local M = {}

-- Mutates table t1
--
---@param t1 table
---@param t2 table
---@return table t1 with t2 appended to it
M.concat = function(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

return M
