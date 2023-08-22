local tools = require("dko.tools")

tools.register({
  type = "lsp",
  require = "go",
  name = "gopls",
  runner = "lspconfig",
})
