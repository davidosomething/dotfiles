local tools = require("dko.tools")

tools.register({
  type = "lsp",
  require = "npm",
  name = "stylelint_lsp",
  runner = "lspconfig",
})
