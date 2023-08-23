local M = {}

M.get_node_modules_dir = function(opts)
  if vim.b.node_modules_dir == nil then
    local find_opts = vim.tbl_extend("force", {
      limit = 1,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      type = "directory",
      upward = true,
    }, opts or {})
    local res = vim.fs.find("node_modules", find_opts)
    vim.b.node_modules_dir = res[1] or false
  end
  return vim.b.node_modules_dir
end

M.get_eslint = function()
  if vim.b.eslint == nil then
    local nmd = M.get_node_modules_dir()
    if nmd == false then
      return false
    end
    local eslint_path = vim.fs.joinpath(nmd, ".bin/eslint")
    vim.b.eslint = require("dko.utils.file").find_exists({ eslint_path })
      or false
  end
  return vim.b.eslint
end

---@return table|nil -- lua table
M.get_eslint_config = function()
  local eslint = M.get_eslint()
  if eslint then
    local json = vim
      .system({ eslint, "--print-config", vim.api.nvim_buf_get_name(0) })
      :wait().stdout
    if json and json:len() then
      return vim.json.decode(json)
    end
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
