-- Typescript specific

local Methods = vim.lsp.protocol.Methods
local handle_definition = vim.lsp.handlers[Methods.textDocument_definition]

local definition_handler = function(...)
  local args = { ... }
  local res = args[2] or {}
  if vim.tbl_isempty(res) then
    return false
  end
  handle_definition(unpack(args))
end

local M = {}

---Go to source definition using LSP command
---@param name 'vtsls'|'tsserver'
---@param command "typescript.goToSourceDefinition"|"_typescript.goToSourceDefinition"
---@return boolean
M.go_to_source_definition = function(name, command)
  local client = vim.lsp.get_clients({ bufnr = 0, name = name })[1]
  if not client then
    vim.notify(("Cannot find %s"):format(name), vim.log.levels.ERROR)
    return false
  end

  local position_params =
    vim.lsp.util.make_position_params(0, client.offset_encoding)
  return client.request(Methods.workspace_executeCommand, {
    command = command,
    arguments = { position_params.textDocument.uri, position_params.position },
  }, definition_handler, 0)
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
