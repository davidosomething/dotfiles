---@type vim.lsp.Config
return {
  ---note: local on_attach happens AFTER autocmd LspAttach
  on_attach = function(client)
    -- The implementation is primitive
    -- https://github.com/microsoft/compose-language-service/blob/main/src/service/providers/DocumentFormattingProvider.ts
    -- Let yamlls should do it instead
    client.server_capabilities.documentFormattingProvider = false
  end,
}
