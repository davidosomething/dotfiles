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

---@return string
M.read_package_json = function()
  return require("dko.utils.file").read_into_vimb(
    "package_json_contents",
    "package.json"
  )
end

---@param pkg string e.g. "prettier"
---@return boolean -- true if found in eslint config
M.has_package = function(pkg)
  local package_json_contents = M.read_package_json()
  -- treat dashes as plain chars
  local PLAIN = true
  return package_json_contents:find(pkg, 1, PLAIN) ~= nil
end

return M
