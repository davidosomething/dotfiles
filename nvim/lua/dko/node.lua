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

M.get_eslint = function()
  return M.get_bin("eslint")
end

---@return table|nil -- lua table
M.get_eslint_config = function()
  local json = vim
    .system({
      M.get_eslint(),
      "--print-config",
      vim.api.nvim_buf_get_name(0),
    })
    :wait().stdout

  if json and json:len() then
    return vim.json.decode(json)
  end

  return nil
end

---@param name string like "prettier/prettier"
---@return boolean -- if found in eslint config
M.has_eslint_plugin = function(name)
  local config = M.get_eslint_config()
  return config and config.plugins and vim.list_contains(config.plugins, name)
    or false
end

return M
