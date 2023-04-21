local M = {}

M.definition = function()
  local client = require("dko.lsp").get_active_client("cssmodules_ls")
  if not client then
    vim.notify("could not get cssmodules_ls", vim.log.levels.ERROR)
    return false
  end
end

return M
