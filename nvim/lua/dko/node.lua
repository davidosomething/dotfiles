local M = {}

M.get_nx_json = function()
  if vim.b.nx_json == nil then
    vim.b.nx_json = vim.fs.find("nx.json", {
      limit = 1,
      path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
      type = "file",
      upward = true,
    })[1] or false
  end
  return vim.b.nx_json
end

-- Find node_modules directory relative to the nx root if in an nx monorepo,
-- or closest to the current file
M.get_node_modules_dir = function()
  if vim.b.node_modules_dir == nil then
    local find_opts = { type = "directory" }
    if M.get_nx_json() then
      find_opts.path = vim.fn.fnamemodify(M.get_nx_json(), ":h")
      find_opts.upward = false
    else
      find_opts.path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      find_opts.upward = true
    end
    vim.b.node_modules_dir = vim.fs.find("node_modules", find_opts)[1] or false
  end
  return vim.b.node_modules_dir
end

---@TODO support both nx root and app local search
---@return string|false -- path to eslint
M.get_eslint = function()
  if vim.b.eslint == nil then
    local nmd = M.get_node_modules_dir()
    if not nmd then
      return false
    end
    local eslint_path = vim.fs.joinpath(nmd, ".bin/eslint")
    vim.b.eslint = require("dko.utils.file").find_exists({ eslint_path })
      or false
  end
  return vim.b.eslint
end

local eslints = {}

-- Return eslint config, cached by path of the eslint binary so multiple files
-- in same project won't have to repeat json decode.
---@param bin? string path to eslint
---@return table|nil -- lua table
M.get_eslint_config = function(bin)
  local eslint = bin or M.get_eslint()
  if not eslint then
    return nil
  end
  if eslints[eslint] == nil then
    local json = vim
      .system({ eslint, "--print-config", vim.api.nvim_buf_get_name(0) })
      :wait().stdout
    eslints[eslint] = json and json:len() > 0 and vim.json.decode(json)
  end
  return eslints[eslint]
end

---@param plugin_name string e.g. "prettier"
---@return boolean -- true if found in eslint config
M.has_eslint_plugin = function(plugin_name)
  local config = M.get_eslint_config()
  return config
      and config.plugins
      and vim.list_contains(config.plugins, plugin_name)
    or false
end

return M
