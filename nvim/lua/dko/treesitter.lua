local M = {}

M.is_highlight_enabled = function(bufnr)
  bufnr = vim.fn.bufnr(bufnr or 0)
  return bufnr > -1 and vim.treesitter.highlighter.active[bufnr] ~= nil
end

return M
