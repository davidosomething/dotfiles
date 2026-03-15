---@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
      validate = { enable = true },
    },
  },
}
