local M = {}

---Replace the front of a path with a named directory shortcut
---e.g., /home/user/projects/myapp/src -> ~PROJ/myapp/src
---@param path string
---@return string -- path with named dir replacement, or home-tilde if no match
M.replace_named_dir = function(path)
  local nameddirs = require("dko.zsh.nameddirs")
  local found = nameddirs.find(path)
  if found and found.name and found.path then
    -- remove prefix and trailing slash, then prepend ~name
    local rest = path:sub(found.path:len() + 2) -- +2 to skip trailing "/"
    return ("~%s/%s"):format(found.name, rest)
  end
  return vim.fn.fnamemodify(path, ":~")
end

---Compact directory segments to fit within container_width minus padding.
---The last segment (leaf) is not shortened by pathshorten.
---A named dir prefix (~name/) is preserved and never compacted.
---@param path string -- path, optionally with ~name/ prefix from replace_named_dir
---@param padding integer -- space consumed by other UI elements
---@param container_width integer -- total available width
---@return string -- compacted path
M.compact_dir = function(path, padding, container_width)
  local prefix = ""
  local target = path
  -- preserve named dir prefix (~name/) from compaction
  local named_prefix = path:match("^(~[^/]+/)")
  if named_prefix then
    prefix = named_prefix
    target = path:sub(named_prefix:len() + 1)
  end
  local _, longest = M.longest_subdir(target)
  local remaining = container_width - padding
  while longest > 1 and (prefix .. target):len() > remaining do
    longest = longest - 1
    target = vim.fn.pathshorten(target, longest)
  end
  return prefix .. target
end

M.longest_subdir = function(path)
  local dirs = vim.split(path, "/")
  return require("dko.utils.string").longest(dirs)
end

---Compute a display-friendly relative path from base to target.
---Returns up-level notation ("." or "…N") and the subpath under the common root.
---@param base string -- e.g., ~/projects/foo
---@param target string -- e.g., ~/projects/bar/src
---@return { up: string, relative: string, levels: integer }|nil
--  nil if no common root; relative == "" means target is inside base
M.relative_display = function(base, target)
  local cr = M.common_root(base, target)
  if cr.root == "" then
    return nil
  end
  local up = cr.levels == 0 and "."
    or ("…%d"):format(cr.levels)
  return { up = up, relative = cr.b, levels = cr.levels }
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
