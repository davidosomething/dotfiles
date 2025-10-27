local tools = require("dko.tools")

tools.register({
  name = "csharp_ls",
  mason_type = "lsp",
  require = "csharp-ls",
  runner = "mason-lspconfig",
})
