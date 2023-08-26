local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  require = "go",
  name = "gopls",
  runner = "mason-lspconfig",
})
