local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  efm = function()
    return {
      languages = { "json", "jsonc" },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})

-- not used for formatting - prefer prettier since it does one-line arrays
-- when they fit
tools.register({
  type = "lsp",
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
