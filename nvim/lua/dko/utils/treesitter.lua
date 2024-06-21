local M = {}

M.is_highlight_enabled = function(bufnr)
  bufnr = bufnr and vim.fn.bufnr(bufnr) or vim.fn.bufnr()
  return bufnr > -1 and vim.treesitter.highlighter.active[bufnr] ~= nil
end

return M
