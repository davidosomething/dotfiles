local M = {}

---Detect eslint-plugin-prettier is installed
M.has_biome = function()
  if vim.b.has_biome == nil then
    vim.b.has_biome = require("dko.utils.node").has_package("biome")
  end
  return vim.b.has_biome
end

return M
