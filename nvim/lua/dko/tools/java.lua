local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  require = "java",
  name = "jdtls",
  runner = "mason-lspconfig",
})
