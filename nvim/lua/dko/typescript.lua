-- Typescript specific

local M = {}

M.source_definition = function()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "tsserver" })
  if #clients == 0 then
    vim.notify("could not get tsserver", vim.log.levels.ERROR)
    return false
  end

  local client = clients[1]

  local position = vim.lsp.util.make_position_params(0, client.offset_encoding)

  local callback = function(...)
    local args = { ... }
    vim.print(args)
    local res = args[2] or {}
    if vim.tbl_isempty(res) then
      return false
    end

    ---@TODO put results into telescope list instead
    --this will immediately jump to source definition
    local method = vim.lsp.protocol.Methods.textDocument_definition
    local handler = client.handlers[method] or vim.lsp.handlers[method]
    handler(unpack(args))
  end

  return client.request(vim.lsp.protocol.Methods.workspace_executeCommand, {
    command = "_typescript.goToSourceDefinition",
    arguments = {
      position.textDocument.uri,
      position.position,
    },
  }, callback, 0)
end

return M
