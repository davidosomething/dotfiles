---@type vim.lsp.Config
return {
  ---note: local on_attach happens AFTER autocmd LspAttach
  on_attach = function(client)
    -- basedpyright instead
    client.server_capabilities.hoverProvider = false
  end,
}
