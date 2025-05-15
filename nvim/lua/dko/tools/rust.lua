local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "rust_analyzer",
  runner = "mason-lspconfig",
})
