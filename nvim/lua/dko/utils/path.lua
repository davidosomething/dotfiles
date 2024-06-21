local M = {}

---Find the common root between two thats
---@param a string
---@param b string
---@return { levels: integer, root: string, a: string, b: string }
M.common_root = function(a, b)
  local ap = vim.split(a, "/")
  local bp = vim.split(b, "/")

  local root = {}
  for i = 1, #ap do
    if ap[1] == bp[1] then
      table.insert(root, ap[1])
      table.remove(ap, 1)
      table.remove(bp, 1)
    else
      return {
        levels = #ap,
        root = table.concat(root, "/"),
        a = table.concat(ap, "/"),
        b = table.concat(bp, "/"),
      }
    end
  end
  return {
    levels = #ap,
    root = table.concat(root, "/"),
    a = table.concat(ap, "/"),
    b = table.concat(bp, "/"),
  }
end

return M
