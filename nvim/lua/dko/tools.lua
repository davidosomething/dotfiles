-- External tool management

---@alias ToolType
---|'"lsp"'
---|'"tool"'

---@class EfmLanguageConfig
---@field languages string[]
---@field config table

---@class Tool
---@field type ToolType
---@field require string
---@field name string
---@field runner? string|string[]
---@field efm? fun(): EfmLanguageConfig

---@alias ToolGroup table<string, boolean>
---@alias ToolGroups table<string, ToolGroup>

local M = {}
---@type ToolGroups
M.tools_group = {}
---@type ToolGroups
M.lsps_group = {}

local efm_resolvers = {}
local efm_languages = nil

---@param config Tool
M.register = function(config)
  local map = config.type == "tool" and M.tools_group or M.lsps_group
  map[config.require] = map[config.require] or {}
  map[config.require][config.name] = true

  if type(config.efm) == "function" then
    table.insert(efm_resolvers, config.efm)
  end
end

---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups M.tools_group or M.lsps_group
---@param category string for logging only
---@return ToolGroups --- { ["npm"] = { "prettier" = {...config} } if npm is executable
M.filter_executable_groups = function(category, groups)
  return require("dko.utils.table").filter(groups, function(_, bin)
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
-- Must then be configured, e.g. as null-ls formatter or diagnostic provider
---@return string[]
M.get_tools = function()
  if tools == nil then
    tools = M.groups_to_tools(M.filter_executable_groups("tool", M.tools_group))
  end
  return tools
end

local lsps = nil
-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_lsps = function()
  if lsps == nil then
    lsps = M.groups_to_tools(M.filter_executable_groups("lsp", M.lsps_group))
  end
  return lsps
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

return M
