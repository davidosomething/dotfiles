local M = {}

M.groups = {}

M.augroup = function(name, opts)
  if not M.groups[name] then
    opts = opts or {}
    M.groups[name] = vim.api.nvim_create_augroup(name, opts)
  end
  return M.groups[name]
end

return M
