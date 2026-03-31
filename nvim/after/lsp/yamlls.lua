--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/yamlls.lua

---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.yamlls
  settings = {
    yaml = {
      format = { enable = false }, -- prefer yamlfmt
      validate = false, -- prefer yamllint
      redhat = { telemetry = { enabled = false } },
      -- disable built-in fetch schemas, prefer schemastore.nvim
      schemaStore = { enable = false },
      schemas = require("schemastore").yaml.schemas({
        ignore = { "Cheatsheets" },
      }),
    },
  },
}
