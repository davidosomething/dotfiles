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

---Not deprecated since much simpler than Iter:filter():fold()
---(:totable() makes pair lists, doesn't make a hash)
M.filter = function(t, func)
  local res = {}
  for k, v in pairs(t) do
    if func(v, k, t) then
      res[k] = v
    end
  end
  return res
end

--- Append or create table with val
M.append = function(t, val)
  if t == nil then
    return { val }
  end
  table.insert(t, val)
  return t
end

return M
