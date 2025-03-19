local dkostring = require("dko.utils.string")

local M = {}

M.longest_subdir = function(path)
  local dirs = vim.split(path, "/")
  return dkostring.longest(dirs)
end

---Run pathshorten at decreasing lengths until fits in space
---@param space integer
---@param path string
---@return string -- shortened to fit space, or down to 1-char segments
M.fit = function(space, path)
  local segments = vim.split(path, "/")

  local longest = 0
  for _, segment in ipairs(segments) do
    longest = segment:len() > longest and segment:len() or longest
  end

  local final
  local len = longest
  while len > 0 and type(final) ~= "string" do
    local attempt = vim.fn.pathshorten(path, len)
    final = attempt:len() < space and attempt
    len = len - 1
  end
  if not final then
    final = vim.fn.pathshorten(path, 1)
  end
  return final
end

---Find the common root between two paths
---@param a string
---@param b string
---@return { levels: integer, root: string, a: string, b: string }
M.common_root = function(a, b)
  local ap = vim.split(a, "/")
  local bp = vim.split(b, "/")

  local root = {}
  for _ = 1, #ap do
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
