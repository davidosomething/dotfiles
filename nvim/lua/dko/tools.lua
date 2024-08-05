local dkotable = require("dko.utils.table")

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

-- nvim-lspconfig config object
-- copypasta from https://github.com/neovim/nvim-lspconfig/blob/8917d2c830e04bf944a699b8c41f097621283828/lua/lspconfig/configs.lua#L8C1-L15C71
--- @class lspconfig.Config : vim.lsp.ClientConfig
--- @field enabled? boolean
--- @field single_file_support? boolean
--- @field filetypes? string[]
--- @field filetype? string
--- @field on_new_config? function
--- @field autostart? boolean
--- @field package _on_attach? fun(client: vim.lsp.Client, bufnr: integer)

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
---@field skip_init? boolean -- e.g. for tsserver, we use typescript-tools.nvim to init and not mason-lspconfig

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
    if config.mason_type ~= "lsp" and config.mason_type ~= "tool" then
      vim.notify(
        ("Invalid mason_type %s for %s"):format(config.mason_type, config.name),
        vim.log.levels.ERROR
      )
    else
      local req = config.require or "_"
      local group = M.install_groups[config.mason_type]
      group[req] = group[req] or {}
      group[req][config.name] = true
    end
  end

  -- ===========================================================================
  -- Register EFM
  -- ===========================================================================
  if config.efm then
    vim.iter(config.fts or {}):each(function(ft)
      efm_filetypes[ft] = true
    end)
    table.insert(efm_configs, config)
    return
  end

  -- ===========================================================================
  -- Register LSP
  -- ===========================================================================
  local config_map
  if config.runner == "lspconfig" then
    config_map = lspconfig_resolvers
  elseif config.runner == "mason-lspconfig" then
    config_map = mason_lspconfig_resolvers
  end
  if config_map == nil then
    return
  end

  -- make sure mason-lspconfig does not try to automatically setup this lsp
  if config.skip_init ~= nil then
    config_map[config.name] = function()
      return function()
        -- noop
      end
    end
  end

  -- this lsp has a custom setup function
  if config.lspconfig then
    -- define resolver for a tool
    -- set up the lspconfig with the lspconfig() function from tool registration
    config_map[config.name] = function(middleware)
      -- middleware or noop middleware
      middleware = middleware
        or function(lspconfig)
          return lspconfig or {}
        end

      -- set up lsp
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

local fegcache = {}
---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups
---@param category string for logging only
---@return ToolGroups --- { ["npm"] = { "prettier" = {...config} } if npm is executable
M.filter_executable_groups = function(category, groups)
  if not fegcache[category] then
    fegcache[category] = dkotable.filter(groups, function(_, bin)
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
  return fegcache[category]
end

---@param groups ToolGroups { ["npm"] = { "black" = {...config},... }
---@return string[] --- { "black", "isort", "shellcheck", ... }
M.groups_to_tools = function(groups)
  local result = {}
  for _, items in pairs(groups) do
    for name in pairs(items) do
      table.insert(result, name)
    end
  end
  return result
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

-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_mason_lsps = function()
  return M.groups_to_tools(
    M.filter_executable_groups("mason-lsp", M.install_groups.lsp)
  )
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

-- calling resolver() eventually calls the lsp_resolver from appropriate
-- config_map, i.e. it does
-- require("lspconfig")[config.name].setup(middleware(config.lspconfig()))
-- to initialize the lsp
---@param middleware? LspconfigMiddleware
M.setup_unmanaged_lsps = function(middleware)
  vim.iter(lspconfig_resolvers):each(function(_, resolver)
    resolver(middleware)()
  end)
end

return M
