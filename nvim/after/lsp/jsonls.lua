---@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas({
        extra = {
          {
            description = "coc.nvim",
            fileMatch = "coc-settings.json",
            name = "coc-settings.json",
            url = "https://raw.githubusercontent.com/neoclide/coc.nvim/master/data/schema.json",
          },
        },
      }),
      -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
      validate = { enable = true },
    },
  },
}
