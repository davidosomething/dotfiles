local M = {}

---@return number
M.status_width = function()
  return vim.o.laststatus == 3 and vim.o.columns
    or vim.api.nvim_win_get_width(0)
end

return M
