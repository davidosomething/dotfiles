local M = {}

---Detect eslint-plugin-prettier is installed
M.has_eslint_plugin_prettier = function()
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier =
      require("dko.utils.node").has_package("eslint-plugin-prettier")
  end
  return vim.b.has_eslint_plugin_prettier
end

return M
