local tools = require("dko.tools")

tools.register({
  type = "lsp",
  require = "_",
  name = "jdtls",
  runner = "lspconfig",
})
