local M = {}

---Given a list of paths, return the first one that exists
---@param paths string[]
---@return string|nil -- normalized path to first found file
M.find_exists = function(paths)
  return vim.iter(paths):find(function(path)
    return vim.uv.fs_stat(vim.fs.normalize(path)) ~= nil
  end)
end

---Edit file with name, look upwards from current buffer
---@param filename string needle
---@param opts? table for vim.fs.find
M.edit_closest = function(filename, opts)
  opts = vim.tbl_extend("force", {
    -- need to specify closest to current file or else cwd is used
    path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
    upward = true,
    type = "file",
  }, opts or {})
  local match = vim.fs.find(filename, opts)
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end

return M
