-- LSP floating window borders
-- Add default rounded border and suppress no info messages
-- E.g. used by /usr/share/nvim/runtime/lua/vim/lsp/handlers.lua
-- To see example of this fn used, press K for LSP hover
-- Overriding with vim.lsp.with is the way recommended by docs (as opposed to
-- overriding vim.lsp.util.open_floating_preview entirely)

vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_hover] =
  vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    silent = true,
  })

vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_signatureHelp] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    silent = true,
  })
