-- Typescript specific

local Methods = vim.lsp.protocol.Methods

local M = {}

M.vtsls_source_definition = function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, Methods.workspace_executeCommand, {
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  })
end

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
  handler = handler
    or client.handlers[Methods.textDocument_definition]
    or vim.lsp.handlers[Methods.textDocument_definition]

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

M.tsserver = {}
M.tsserver.inlay_hint_settings = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

---@type lspconfig.Config
M.tsserver.config = {
  on_attach = function(client, bufnr)
    require("dko.mappings").bind_tsserver_lsp(client, bufnr)
    local twoslashok, twoslash = pcall(require, "twoslash-queries")
    if twoslashok then
      twoslash.attach(client, bufnr)
    end
  end,

  handlers = {
    [vim.lsp.protocol.Methods.textDocument_publishDiagnostics] = function(
      _,
      result,
      ctx,
      config
    )
      if not result.diagnostics then
        return
      end

      -- ignore some tsserver diagnostics
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]

        local formatter = require("format-ts-errors")[entry.code]
        entry.message = formatter and formatter(entry.message) or entry.message

        -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        if entry.code == 80001 then
          -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },

  settings = {
    typescript = { inlayHints = M.tsserver.inlay_hint_settings },
    javascript = { inlayHints = M.tsserver.inlay_hint_settings },
  },
}

return M
