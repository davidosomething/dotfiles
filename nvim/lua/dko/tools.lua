---@alias ft string -- filetype

---Abstract class for efm tools
---@class EfmToolConfig
---@field requireMarker? boolean
---@field rootMarkers? string[]

---Return type for a tool's efm function that is a formatter
---@class EfmFormatter: EfmToolConfig
---@field formatCommand string -- executable and args
---@field formatCanRange? boolean
---@field formatStdIn? boolean

---Return type for a tool's efm function that is a linter
---@class EfmLinter: EfmToolConfig
---@field lintCommand string -- executable and args
---@field lintSource? 'efm' | 'efmls' -- displays above float
---@field lintStdIn? boolean
---@field prefix? string

---@class Tool
---@field name string -- tool or lspconfig name
---@field runner? 'lspconfig'
---@field fts? ft[] -- for efm, list of filetypes to register
---@field efm? fun(): EfmFormatter|EfmLinter
---@field skip_init? boolean -- e.g. for ts_ls, we use typescript-tools.nvim to init and not raw lspconfig

---@alias ToolGroup table<string, boolean>
---@alias ToolGroups table<string, ToolGroup>

local M = {}

---@type string[]
M.standalone_lsp_names = {}

--- This is the Tool config that has a .efm() method, not the result of calling
--- the efm() method itself. We cannot call until plugins loaded.
---@type table<ft, Tool[]>
M.config_with_efm_by_ft = {}

--- Process the tool definition
---@param config Tool
M.register = function(config)
  if config.fts and config.efm then
    vim.iter(config.fts):each(function(ft)
      M.config_with_efm_by_ft[ft] = require("dko.utils.table").append(
        M.config_with_efm_by_ft[ft],
        config
      )
    end)
    return
  end

  if config.runner == 'lspconfig' then
    table.insert(M.standalone_lsp_names, config.name)
  end
end

return M
