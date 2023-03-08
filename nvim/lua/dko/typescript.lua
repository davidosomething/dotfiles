local M = {}

M.source_definition = function(bufnr)
  local ok, executeCommandModule = pcall(require, "typescript.execute-command")
  if not ok then
    return false
  end

  local client = require('dko.lsp').get_active_client('tsserver')
  if not client then
    vim.notify('could not get tsserver', vim.log.levels.ERROR)
    return false
  end

  local positionParams = vim.lsp.util.make_position_params(0, client.offset_encoding)

  local commands = require("typescript.types.workspace-commands").WorkspaceCommands
  local Methods = require("typescript.types.methods").Methods
  local resolveHandler = require("typescript.utils").resolveHandler

  local requestOk = executeCommandModule.executeCommand(
    bufnr,
    {
      command = commands.GO_TO_SOURCE_DEFINITION,
      arguments = {
        positionParams.textDocument.uri,
        positionParams.position
      }
    },
    function(...)
        local args = {...}
        local handler = resolveHandler(bufnr, Methods.DEFINITION)
        if not handler then
            print("failed to go to source definition: could not resolve definition handler")
            return
        end
        local res = args[2] or ({})
        if vim.tbl_isempty(res) then
          return false
        end
        vim.pretty_print(args)
        handler(unpack(args))
    end
  )

  if not requestOk then
      print("failed to go to source definition: tsserver request failed")
  end
  return requestOk
end

return M
