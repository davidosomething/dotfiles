---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      format = { enable = false }, -- prefer yamlfmt
      validate = { enable = true }, -- prefer yamllint
      redhat = { telemetry = { enabled = false } },
      -- disable built-in fetch schemas, prefer schemastore.nvim
      schemaStore = { enable = false },
      schemas = require("schemastore").yaml.schemas({
        ignore = { "Cheatsheets" },
      }),
    },
  },
}
