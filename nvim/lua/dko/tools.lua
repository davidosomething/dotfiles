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
---@class lspconfig.Config : vim.lsp.ClientConfig
---@field cmd? string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
---@field enabled? boolean
---@field single_file_support? boolean
---@field filetypes? ft[]
---@field filetype? ft
---@field on_new_config? function
---@field autostart? boolean
---@field package _on_attach? fun(client: vim.lsp.Client, bufnr: integer)

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
---@field skip_init? boolean -- e.g. for ts_ls, we use typescript-tools.nvim to init and not mason-lspconfig

---@alias ToolGroup table<string, boolean>
---@alias ToolGroups table<string, ToolGroup>

local M = {}
---@type { tool: ToolGroups[], lsp: ToolGroups[] }
M.install_groups = { tool = {}, lsp = {} }

---@alias LspconfigMiddleware fun(table): table
---@alias LspconfigResolver fun(middleware?: LspconfigMiddleware): LspconfigDef

---@type table<string, LspconfigResolver>
M.mason_lspconfig_resolvers = {}

---@type table<string, LspconfigResolver>
M.lspconfig_resolvers = {}

local runner_to_resolvers_map = {
  ["lspconfig"] = M.lspconfig_resolvers,
  ["mason-lspconfig"] = M.mason_lspconfig_resolvers,
}

---@type Tool[] with efm defined
local efm_configs = {}

---@type table<ft, boolean>
local efm_filetypes = {}

local function noop_resolver()
  return function()
    -- noop
  end
end

local function middleware_pass(lspconfig)
  return lspconfig or {}
end

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
  if config.runner then
    local config_map = runner_to_resolvers_map[config.runner]
    config_map[config.name] = function(middleware)
      middleware = middleware or middleware_pass
      local lspconfig = config.lspconfig and config.lspconfig() or {}
      local middleware_applied = middleware(lspconfig)
      return middleware_applied
    end
  end
end

M.get_efm_filetypes = function()
  return vim.tbl_keys(efm_filetypes)
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
      acc[ft] = dkotable.append(acc[ft], config.efm())
    end
    return acc
  end)
end

--- cache for filter_executable_groups
local fegcache = {}

---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups
---@param category string for logging only
---@return ToolGroups --- { ["npm"] = { "prettier" = {...config} } if npm is executable
M.filter_executable_groups = function(category, groups)
  if not fegcache[category] then
    fegcache[category] = dkotable.filter(groups, function(tool_configs, bin)
      if bin ~= "_" and vim.fn.executable(bin) == 0 then
        ---@TODO maybe don't report here
        local tool_names = table.concat(vim.tbl_keys(tool_configs), ", ")
        require("dko.doctor").warn({
          category = category,
          message = ("[%s] Executable `%s` not found, skipping: %s"):format(
            category,
            bin,
            tool_names
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
---@return string[]
M.get_mason_lsps = function()
  return M.groups_to_tools(
    M.filter_executable_groups("mason-lsp", M.install_groups.lsp)
  )
end

return M
