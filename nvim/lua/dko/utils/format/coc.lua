local M = {}

---Detect coc-prettier is installed
M.has_coc_prettier = function()
  if vim.g.has_coc_prettier == nil then
    vim.g.has_coc_prettier = vim
      .iter(vim.g.coc_global_extensions)
      :find(function(v)
        return string.find(v, "coc%-prettier")
      end)
  end
  return vim.g.has_coc_prettier
end

return M
