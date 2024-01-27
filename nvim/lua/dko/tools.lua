local dkotable = require("dko.utils.table")
local lsp = vim.lsp

---@alias ft string -- filetype

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

-- copypasta https://github.com/neovim/nvim-lspconfig/blob/8917d2c830e04bf944a699b8c41f097621283828/lua/lspconfig/configs.lua#L8C1-L15C71
--- @class lspconfig.Config : lsp.ClientConfig
--- @field enabled? boolean
--- @field single_file_support? boolean
--- @field filetypes? string[]
--- @field filetype? string
--- @field on_new_config? function
--- @field autostart? boolean
--- @field package _on_attach? fun(client: lsp.Client, bufnr: integer)

---@alias LspconfigDef fun(): lspconfig.Config gets passed to lsp's setup()

---@alias MasonToolType
---|'"lsp"'
---|'"tool"'

---@alias ToolName string

---@class Tool
---@field name ToolName -- tool or lspconfig name
---@field mason_type? MasonToolType -- if present, try to install with mason
---@field require? string -- an executable name or _, for mason install
---@field runner? 'lspconfig' | 'mason-lspconfig'
---@field fts? ft[] -- for efm, list of filetypes to register
---@field efm? fun(): EfmFormatter|EfmLinter
---@field lspconfig? LspconfigDef

---@alias ToolGroup table<string, boolean>
---@alias ToolGroups table<string, ToolGroup>

local M = {}
---@type { tool: ToolGroups[], lsp: ToolGroups[] }
M.install_groups = { tool = {}, lsp = {} }

---@alias LspconfigMiddleware fun(table): table
---@alias LspconfigResolver fun(middleware?: LspconfigMiddleware): LspconfigDef

---@type table<string, LspconfigResolver>
local mason_lspconfig_resolvers = {}

---@type table<string, LspconfigResolver>
local lspconfig_resolvers = {}

---@type Tool[] with efm defined
local efm_configs = {}

---@type table<ft, boolean>
local efm_filetypes = {}

---@param config Tool
M.register = function(config)
  if config.mason_type then
    M.install_groups[config.mason_type][config.require] = M.install_groups[config.mason_type][config.require]
      or {}
    M.install_groups[config.mason_type][config.require][config.name] = true
  end

  if config.efm then
    vim.iter(config.fts or {}):each(function(ft)
      efm_filetypes[ft] = true
    end)
    table.insert(efm_configs, config)
  elseif config.lspconfig then
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

M.get_efm_filetypes = function()
  return vim.tbl_keys(efm_filetypes)
end

---@param filter? fun(Tool): boolean -- for iter:filter
---@return table<ft, (EfmLinter|EfmFormatter)[]>
M.get_efm_languages = function(filter)
  local it = vim.iter(efm_configs)
  local filtered = it
  if filter then
    filtered = it:filter(filter)
  end
  return filtered:fold({}, function(acc, config)
    for _, ft in ipairs(config.fts) do
      acc[ft] = acc[ft] or {}
      table.insert(acc[ft], config.efm())
    end
    return acc
  end)
end

---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups
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
    tools = M.groups_to_tools(
      M.filter_executable_groups("tool", M.install_groups.tool)
    )
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
      M.filter_executable_groups("mason-lsp", M.install_groups.lsp)
    )
  end
  return mason_lsps
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
  vim.iter(lspconfig_resolvers):each(function(_, resolver)
    resolver(middleware)()
  end)
end

return M
