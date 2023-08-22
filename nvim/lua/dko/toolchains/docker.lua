local tools = require("dko.tools")

tools.register({
  type = "lsp",
  require = "npm",
  name = "dockerls",
  runner = "lspconfig",
})
