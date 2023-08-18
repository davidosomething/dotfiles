-- External tool management

local M = {}

---Get a list of tools that CAN be installed because required binary available
---@param tbl table map of [required binary]: tool to install
---@param category string
---@return table
M.filter_executable = function(category, tbl)
  return vim.tbl_flatten(
    vim.tbl_values(require("dko.utils.table").filter(tbl, function(_, bin)
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
    end))
  )
end

-- Tools to auto-install with mason
-- Must then be configured, e.g. as null-ls formatter or diagnostic provider
---@return string[]
M.get_auto_installable = function()
  return M.filter_executable("TOOL", {
    ["_"] = {
      "actionlint",
      "selene",
      "shellcheck", -- used by null_ls AND bashls
      "shfmt", -- null_ls formatting
      "stylua",
      "tree-sitter-cli",
      "yamlfmt",
    },
    ["npm"] = {
      "markdownlint",
      "prettier",
    },
    ["python"] = {
      "black",
      "isort",
      "vint",
      "yamllint",
    },
  })
end

-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
---@return string[]
M.get_auto_installable_lsps = function()
  return M.filter_executable("LSP", {
    ["_"] = {
      --"bashls", -- prefer null_ls shellcheck, has code_actions and code inline
      "jdtls",
      "lua_ls",
      -- temporary -- using jedi instead of futzing around with venvs ?
      -- https://github.com/neovim/nvim-lspconfig/issues/500
      -- do :PylspInstall <tab> after to install plugins!!
      --"pylsp",
    },
    ["npm"] = {
      "ansiblels",
      --"cssls", -- conflicts with tailwindcss
      "cssmodules_ls", -- jumping into classnames from jsx/tsx
      "docker_compose_language_service",
      "dockerls",
      "eslint",
      "html",
      "jsonls",
      "stylelint_lsp",
      "tailwindcss",
      "tsserver",
      "vimls",
      "yamlls",
    },
    ["go"] = {
      "efm",
      "gopls",
    },
    ["python"] = {
      -- python hover and some diagnostics from jedi
      -- https://github.com/pappasam/jedi-language-server#capabilities
      "jedi_language_server",

      -- python lint and format from ruff
      "ruff_lsp",
    },
  })
end

return M
