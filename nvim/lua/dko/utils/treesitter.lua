local M = {}

M.is_highlight_enabled = function(bufnr)
  bufnr = bufnr and vim.fn.bufnr(bufnr) or vim.fn.bufnr()
  if bufnr > -1 then
    return vim.treesitter.highlighter.active[bufnr] ~= nil
  end
  return false
end

return M
