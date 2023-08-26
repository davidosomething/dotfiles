local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  require = "_",
  name = "jdtls",
  runner = "mason-lspconfig",
})
