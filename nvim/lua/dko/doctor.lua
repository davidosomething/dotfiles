-- General info about current config and buffers

local M = {}

M.warnings = {}
M.errors = {}

M.error = function(params)
  table.insert(M.errors, params)
end

M.warn = function(params)
  table.insert(M.warnings, params)
end

vim.api.nvim_create_user_command("DKODoctorErrors", function()
  vim.cmd.Bufferize("lua vim.print(require('dko.doctor').errors)")
end, { desc = "Show DKODoctor errors" })

vim.api.nvim_create_user_command("DKODoctorWarnings", function()
  vim.cmd.Bufferize("lua vim.print(require('dko.doctor').warnings)")
end, { desc = "Show DKODoctor warnings" })

return M
