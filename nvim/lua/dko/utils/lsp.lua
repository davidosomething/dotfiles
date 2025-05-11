local M = {}

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
