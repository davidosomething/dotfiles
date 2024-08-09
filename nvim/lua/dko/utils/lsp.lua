local M = {}

M.base_config = {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

-- Function used by a config resolver to modify lsp config
---@param config? table
M.middleware = function(config)
  config = config or {}
  return vim.tbl_deep_extend("force", M.base_config, config)
end

return M
