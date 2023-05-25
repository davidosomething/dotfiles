local M = {}

M.space = function(size)
  vim.notify("set space mode")
  vim.bo.expandtab = true
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

M.tab = function(size)
  vim.notify("set tab mode")
  vim.bo.expandtab = false
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

return M
