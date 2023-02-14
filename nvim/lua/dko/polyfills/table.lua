-- Moves elements [f, e] from array a1 into a2 starting at index t
-- table.move implementation
---@param a1 table from which to draw elements from range
---@param f number starting index for range
---@param e number ending index for range
---@param t number starting index to move elements from a1 within [f, e]
---@param a2 table the second table to move these elements to
---@diagnostic disable-next-line: duplicate-set-field
table.move = function(a1, f, e, t, a2)
  a2 = a2 or a1
  t = t + e
  for i = e, f, -1 do
    t = t - 1
    a2[t] = a1[i]
  end
  return a2
end
