---@param paths table
---@return string|nil path to first file
local function find_exists(paths)
  for _, path in ipairs(paths) do
    ---@diagnostic disable-next-line: missing-parameter
    local normalized = vim.fs.normalize(path)
    local stat = vim.uv.fs_stat(normalized)
    if stat ~= nil then
      return normalized
    end
  end
  return nil
end

return find_exists
