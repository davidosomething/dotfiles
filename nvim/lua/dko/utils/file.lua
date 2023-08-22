local M = {}

---Given a list of paths, return the first one that exists
---@param paths table
---@return string|nil path to first file
M.find_exists = function(paths)
  for _, path in ipairs(paths) do
    local normalized = vim.fs.normalize(path)
    local stat = vim.uv.fs_stat(normalized)
    if stat ~= nil then
      return normalized
    end
  end
  return nil
end

---Edit file with name, look upwards from current buffer
---@param opts table for vim.fs.find
---@param filename string needle
M.edit_closest = function(filename, opts)
  opts = vim.tbl_extend("force", {
    -- need to specify closest to current file or else cwd is used
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    upward = true,
    type = "file",
  }, opts or {})
  local match = vim.fs.find(filename, opts)
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end

return M
