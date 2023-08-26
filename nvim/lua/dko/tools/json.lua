local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "json", "jsonc" },
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

-- not used for formatting - prefer prettier since it does one-line arrays
-- when they fit
tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "jsonls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
          validate = { enable = true },
        },
      },
    }
  end,
})
