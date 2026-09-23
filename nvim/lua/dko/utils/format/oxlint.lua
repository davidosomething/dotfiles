local M = {}

---@return vim.lsp.Client|nil
M.get_client = function()
  return vim.lsp.get_clients({ bufnr = 0, name = "oxlint" })[1]
end

---Apply oxlint's autofixes, if it is attached
---Not :LspOxlintFixAll -- that is async, so on BufWritePre the edits could
---land after the formatter ran or after the write.
---@return boolean -- whether oxlint ran
M.fix_all = function()
  local client = M.get_client()
  if not client then
    return false
  end

  local bufnr = vim.api.nvim_get_current_buf()
  client:request_sync("workspace/executeCommand", {
    command = "oxc.fixAll",
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }, require("dko.utils.format").timeout_ms(), bufnr)

  require("dko.utils.notify").toast("oxlint", vim.log.levels.INFO, {
    group = "format",
    title = "[LSP] oxlint",
    render = "wrapped-compact",
  })
  return true
end

return M
