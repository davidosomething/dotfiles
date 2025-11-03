local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "html" },
  efm = require("dko.tools.prettier").efm,
})

tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "html",
  runner = "mason-lspconfig",
})
