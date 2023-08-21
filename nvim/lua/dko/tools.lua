-- External tool management

local M = {}

M.tools = {
  ["_"] = {
    ["tree-sitter-cli"] = true,
  },
  ["npm"] = {
    ["markdownlint"] = true,
    ["prettier"] = true, -- efm
  },
}

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
    ["efm"] = true,
    ["gopls"] = true,
  },
}

M.register_tool = function(config)
  M.tools[config.require] = M.tools[config.require] or {}
  M.tools[config.require][config.name] = config
end

M.register_lsp = function(config)
  M.lsps[config.require] = M.lsps[config.require] or {}
  M.lsps[config.require][config.name] = config
end

---Get a list of tools that CAN be installed because required binary available
---@param tbl table map of [required binary]: tool to install
---@param category string for logging only
---@return table
M.filter_executable_groups = function(category, tbl)
  return require("dko.utils.table").filter(tbl, function(_, bin)
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
  return M.groups_to_tools(M.filter_executable_groups("TOOL", M.tools))
end

-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_auto_installable_lsps = function()
  return M.groups_to_tools(M.filter_executable_groups("LSP", M.lsps))
end

return M
