return {
  --- Use :LspStart cssmodules_ls to start this
  autostart = false,

  ---note: local on_attach happens AFTER autocmd LspAttach
  on_attach = function(client)
    -- https://github.com/davidosomething/dotfiles/issues/521
    -- https://github.com/antonk52/cssmodules-language-server#neovim
    -- avoid accepting `definitionProvider` responses from this LSP
    client.server_capabilities.definitionProvider = false
  end,
}
