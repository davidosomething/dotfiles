-- External tool management

---@class Tool
---@field type 'lsp'|'tool'
---@field require string
---@field name string
---@field runner? string|string[]

---@alias ToolGroup table<string, Tool>

---@alias ToolGroups table<string, ToolGroup|table<string, boolean>>

local M = {}

---@type ToolGroups
M.tools = {
  ["npm"] = {
    ["markdownlint"] = true,
    ["prettier"] = true, -- efm
  },
}

---@type ToolGroups
M.lsps = {
  ["_"] = {
    ["jdtls"] = true,
  },
  ["npm"] = {
    --"cssls", -- conflicts with tailwindcss
    ["cssmodules_ls"] = true, -- jumping into classnames from jsx/tsx
    ["dockerls"] = true,
    ["eslint"] = true,
    ["html"] = true,
    ["jsonls"] = true,
    ["stylelint_lsp"] = true,
    ["tailwindcss"] = true,
    ["tsserver"] = true,
  },
  ["go"] = {
    ["gopls"] = true,
  },
}

---@param config Tool
M.register = function(config)
  local map = config.type == "tool" and M.tools or M.lsps
  map[config.require] = map[config.require] or {}
  map[config.require][config.name] = config
end

---Get a list of tools that CAN be installed because required binary available
---@param groups ToolGroups M.tools or M.lsps
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

-- Tools to auto-install with mason
-- Must then be configured, e.g. as null-ls formatter or diagnostic provider
---@return string[]
M.get_auto_installable = function()
  return M.groups_to_tools(M.filter_executable_groups("tool", M.tools))
end

-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_auto_installable_lsps = function()
  return M.groups_to_tools(M.filter_executable_groups("lsp", M.lsps))
end

return M
