-- LSP floating window borders
-- Add default rounded border and suppress no info messages
-- E.g. used by /usr/share/nvim/runtime/lua/vim/lsp/handlers.lua
-- To see example of this fn used, press K for LSP hover
-- Overriding with vim.lsp.with is the way recommended by docs (as opposed to
-- overriding vim.lsp.util.open_floating_preview entirely)

local lsp = vim.lsp
local handlers = lsp.handlers
local Methods = lsp.protocol.Methods

local config = {
  border = require("dko.settings").get("border"),
  silent = true,
}

handlers[Methods.textDocument_hover] = lsp.with(handlers.hover, config)
handlers[Methods.textDocument_signatureHelp] =
  lsp.with(handlers.signature_help, config)
