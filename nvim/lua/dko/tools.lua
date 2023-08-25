local dkotable = require("dko.utils.table")

-- External tool management

---@alias ToolType
---|'"lsp"'
---|'"tool"'

---@class EfmToolConfig
---@field requireMarker? boolean
---@field rootMarkers? string[]

---@class EfmFormatter: EfmToolConfig
---@field formatCommand string -- executable and args
---@field formatCanRange? boolean
---@field formatStdIn? boolean

---@class EfmLinter: EfmToolConfig
---@field lintCommand string -- executable and args
---@field lintSource? 'efm' | 'efmls' -- displays above float
---@field lintStdIn? boolean
---@field prefix? string

---@class EfmDef
---@field languages string[]
---@field config EfmFormatter|EfmLinter

---@alias LspconfigDef fun(): table gets passed to lsp's setup()

---@class Tool
---@field type ToolType
---@field name string -- tool or lspconfig name
---@field install? boolean -- nil = true
---@field require? string -- an executable name or _
---@field runner? 'lspconfig' | 'mason-lspconfig'
---@field efm? fun(): EfmDef
---@field lspconfig? LspconfigDef

---@alias ToolGroup table<string, boolean>
---@alias ToolGroups table<string, ToolGroup>

local M = {}
---@type ToolGroups
M.tools_group = {}
---@type ToolGroups
M.mason_lsps_group = {}

local efm_resolvers = {}
local efm_languages = nil

---@alias LspconfigMiddleware fun(table): table
---@alias LspconfigResolver fun(middleware?: LspconfigMiddleware): LspconfigDef

---@type table<string, LspconfigResolver>
local mason_lspconfig_resolvers = {}

---@type table<string, LspconfigResolver>
local lspconfig_resolvers = {}

---@param config Tool
M.register = function(config)
  if config.install ~= false then
    local map = {} -- throwaway map
    if config.type == "tool" then
      map = M.tools_group
    elseif config.type == "lsp" then
      map = M.mason_lsps_group
    end
    map[config.require] = map[config.require] or {}
    map[config.require][config.name] = true
  end

  if type(config.efm) == "function" then
    table.insert(efm_resolvers, config.efm)
  end

  if type(config.lspconfig) == "function" then
    local config_map
    if config.runner == "lspconfig" then
      config_map = lspconfig_resolvers
    else
      config_map = mason_lspconfig_resolvers
    end
    config_map[config.name] = function(middleware)
      middleware = middleware
        or function(lspconfig)
          return lspconfig or {}
        end
      return function()
        require("lspconfig")[config.name].setup(middleware(config.lspconfig()))
      end
    end
  end
end

---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups M.tools_group or M.mason_lsps_group
---@param category string for logging only
---@return ToolGroups --- { ["npm"] = { "prettier" = {...config} } if npm is executable
M.filter_executable_groups = function(category, groups)
  return dkotable.filter(groups, function(_, bin)
    if bin ~= "_" and vim.fn.executable(bin) == 0 then
      require("dko.doctor").warn({
        category = category,
        message = ("[%s] %s not found, skip installation"):format(
          category,
          bin
        ),
      })
      return false
    end
    return true
  end)
end

---@param groups ToolGroups { ["npm"] = { "black" = {...config},... }
---@return string[] --- { "black", "isort", "shellcheck", ... }
M.groups_to_tools = function(groups)
  local mapped_tools = vim.tbl_map(function(group)
    return vim.tbl_keys(group)
  end, groups)
  return vim.tbl_flatten(vim.tbl_values(mapped_tools))
end

local tools = nil
-- Tools to auto-install with mason
---@return string[]
M.get_tools = function()
  if tools == nil then
    tools = M.groups_to_tools(M.filter_executable_groups("tool", M.tools_group))
  end
  return tools
end

local mason_lsps = nil
-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_mason_lsps = function()
  if mason_lsps == nil then
    mason_lsps = M.groups_to_tools(
      M.filter_executable_groups("mason-lsp", M.mason_lsps_group)
    )
  end
  return mason_lsps
end

---@alias ft string

---@return table<ft, table> -- fit for efm lsp settings.languages
M.get_efm_languages = function()
  if efm_languages == nil then
    efm_languages = {}
    for _, resolver in pairs(efm_resolvers) do
      local resolved = resolver()
      for _, lang in pairs(resolved.languages) do
        efm_languages[lang] = efm_languages[lang] or {}
        table.insert(efm_languages[lang], resolved.config)
      end
    end
  end
  return efm_languages
end

M.get_efm_formatters = function()
  if not vim.b.efm_formatters then
    local configs = M.get_efm_languages()[vim.bo.filetype]
    vim.b.efm_formatters = vim.tbl_filter(function(v)
      return v.formatCommand ~= nil and v.formatCommand:sub(1, 1) ~= " "
    end, configs or {})
  end
  return vim.b.efm_formatters
end

M.get_efm_linters = function()
  if not vim.b.efm_linters then
    local configs = M.get_efm_languages()[vim.bo.filetype]
    vim.b.efm_linters = vim.tbl_filter(function(v)
      return v.lintCommand ~= nil
    end, configs or {})
  end
  return vim.b.efm_linters
end

---@param middleware? LspconfigMiddleware
M.get_mason_lspconfig_handlers = function(middleware)
  ---@type table<string, LspconfigDef>
  local handlers = {}
  for name, resolver in pairs(mason_lspconfig_resolvers) do
    handlers[name] = resolver(middleware)
  end
  return handlers
end

---@param middleware? LspconfigMiddleware
M.setup_unmanaged_lsps = function(middleware)
  vim.iter(lspconfig_resolvers):each(function(name, resolver)
    resolver(middleware)()
  end)
end

return M
