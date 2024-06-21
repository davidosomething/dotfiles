-- Typescript specific

local M = {}

---@alias LocationHandler fun(unused: nil, result: table, ctx: table, config: table): nil
--- result of LSP method; a location or a list of locations.
--- ctx table containing the context of the request, including the method
---(`textDocument/definition` can return `Location` or `Location[]`

---@deprecated using TSToolsGoToSourceDefinition instead
---@param client? lsp.Client tsserver client
---@param handler? LocationHandler
M.source_definition = function(client, handler)
  client = client or vim.lsp.get_clients({ bufnr = 0, name = "tsserver" })[1]
  if not client then
    vim.notify("no tsserver", vim.log.levels.WARN)
    return
  end

  ---@TODO put results into telescope list instead
  ---see https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__lsp.lua#L172-L227
  --this will immediately jump to source definition
  local method = vim.lsp.protocol.Methods.textDocument_definition
  handler = handler or client.handlers[method] or vim.lsp.handlers[method]

  local callback = function(...)
    local args = { ... }
    vim.print(args)
    local res = args[2] or {}
    if vim.tbl_isempty(res) then
      return false
    end
    handler(unpack(args))
  end

  local position = vim.lsp.util.make_position_params(0, client.offset_encoding)
  return client.request(vim.lsp.protocol.Methods.workspace_executeCommand, {
    command = "_typescript.goToSourceDefinition",
    arguments = {
      position.textDocument.uri,
      position.position,
    },
  }, callback, 0)
end

return M
