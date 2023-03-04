local M = {}

---@param command string executable name to look for in node_modules/.bin
---@return string|nil full path to executable
M.get_bin = function(command)
  local ok, cr = pcall(require, "null-ls.helpers.command_resolver")
  if not ok then
    return nil
  end

  -- cached by bufnr
  local resolver = cr.from_node_modules()
  local params = {
    command = command,
    bufnr = vim.api.nvim_get_current_buf(),
    bufname = vim.api.nvim_buf_get_name(0),
  }
  -- on next run the buffer will know the result of resolver from cache
  return resolver(params)
end

return M
