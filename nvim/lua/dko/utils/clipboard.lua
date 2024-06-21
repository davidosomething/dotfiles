local M = {}

M.has_builtin_osc52 = function()
  local has = pcall(require, "vim.ui.clipboard.osc52")
  return has
end

M.should_use_osc52 = function()
  return require("dko.utils.vte").is_remote()
end

return M
