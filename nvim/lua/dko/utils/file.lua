local M = {}

---Get filepath and resolve symlinks for the current buffer
---@return string|nil
M.real_filepath = function()
  local res = vim.fn.expand("%:p", false, false)
  if type(res) ~= "string" then
    return
  end
  res = res == "" and vim.uv.cwd() or res
  if res:len() then
    --- resolve symlink
    local resolved = vim.uv.fs_realpath(res)
    return resolved
  end
  return nil
end

---Given a list of paths, return the first one that exists
---@param paths string[]
---@return string|nil -- normalized path to first found file
M.find_exists = function(paths)
  return vim.iter(paths):find(function(path)
    return vim.fn.getftype(vim.fs.normalize(path)) ~= ""
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

---Read file(s) contents into a buffer variable (cached)
---@param cache_key string -- buffer variable name (e.g. "package_json_contents")
---@param filenames string|string[] -- filename(s) to search for, in priority order
---@return string -- file contents or empty string if not found
M.read_into_vimb = function(cache_key, filenames)
  if vim.b[cache_key] == nil then
    local path = vim.api.nvim_buf_get_name(0)
        and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      or nil
    local files = vim.fs.find(filenames, {
      path = path,
      limit = 1,
      type = "file",
      upward = true,
    })
    if #files > 0 then
      local f = io.input(files[1])
      if f then
        vim.b[cache_key] = f:read("*a")
        f:close()
        return vim.b[cache_key]
      end
    end
    vim.b[cache_key] = ""
  end
  return vim.b[cache_key]
end

return M
