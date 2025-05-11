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

--- Follow textDocument/documentLink if available
--- Uses https://github.com/icholy/lsplinks.nvim
M.follow_documentLink = function()
  local lsplinks_ok, lsplinks = pcall(require, "lsplinks")
  if lsplinks_ok then
    local lsp_url = lsplinks.current()
    -- alternatively use vim.ui.open on lsplinks.current()
    if lsp_url then
      vim.print(("found lsp_url %s"):format(lsp_url))
      vim.ui.open(lsp_url)
      return true
    end
  end
  return false
end

return M
