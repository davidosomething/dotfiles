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
---@type { tool: ToolGroups[], lsp: ToolGroups[] }
M.install_groups = { tool = {}, lsp = {} }

---@type string[]
M.lspconfig_resolvers = {}

local runner_to_resolvers_map = {
  ["lspconfig"] = M.lspconfig_resolvers,
}

---@type Tool[] with efm defined
local efm_configs = {}

---@type table<ft, Tool[]>
M.efm_filetypes = {}

---@param config Tool
M.register = function(config)
  -- ===========================================================================
  -- Register EFM
  -- ===========================================================================
  if config.efm then
    vim.iter(config.fts or {}):each(function(ft)
      M.efm_filetypes[ft] = M.efm_filetypes[ft] or {}
      M.efm_filetypes[ft][config.name] = config
    end)
    table.insert(efm_configs, config)
    return
  end

  -- ===========================================================================
  -- Register LSP
  -- ===========================================================================
  if config.runner then
    table.insert(runner_to_resolvers_map[config.runner], config.name)
  end
end

---@param filter? fun(Tool): boolean -- for iter:filter
---@return table<ft, (EfmLinter|EfmFormatter)[]>
M.get_efm_languages = function(filter)
  filter = filter or function()
    return true
  end
  local filtered_efm_configs = vim.iter(efm_configs):filter(filter)
  return filtered_efm_configs:fold({}, function(acc, config)
    for _, ft in ipairs(config.fts) do
      acc[ft] = require("dko.utils.table").append(acc[ft], config.efm())
    end
    return acc
  end)
end

return M
