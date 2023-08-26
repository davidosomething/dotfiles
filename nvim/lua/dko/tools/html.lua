local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "html" },
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "html",
  runner = "mason-lspconfig",
})
