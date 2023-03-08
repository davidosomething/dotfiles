local M = {}

M.source_definition = function()
  local client = require("dko.lsp").get_active_client("tsserver")
  if not client then
    vim.notify("could not get tsserver", vim.log.levels.ERROR)
    return false
  end

  local position = vim.lsp.util.make_position_params(0, client.offset_encoding)

  local callback = function(...)
    local args = { ... }
    vim.pretty_print(args)
    local res = args[2] or {}
    if vim.tbl_isempty(res) then
      return false
    end

    ---@TODO put results into telescope list instead
    --this will immediately jump to source definition
    local handler = client.handlers["textDocument/definition"]
      or vim.lsp.handlers["textDocument/definition"]
    handler(unpack(args))
  end

  return client.request("workspace/executeCommand", {
    command = "_typescript.goToSourceDefinition",
    arguments = {
      position.textDocument.uri,
      position.position,
    },
  }, callback)
end

return M
