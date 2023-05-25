-- LSP floating window borders
-- Add default rounded border and suppress no info messages
-- E.g. used by /usr/share/nvim/runtime/lua/vim/lsp/handlers.lua
-- To see example of this fn used, press K for LSP hover
-- Overriding with vim.lsp.with is the way recommended by docs (as opposed to
-- overriding vim.lsp.util.open_floating_preview entirely)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  -- suppress 'No information available' notification (nvim-0.9 ?)
  -- https://github.com/neovim/neovim/pull/21531/files#diff-728d3ae352b52f16b51a57055a3b20efc4e992efacbf1c34426dfccbba30037cR339
  silent = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    -- suppress 'No information available' notification (nvim-0.8!)
    silent = true,
  })
