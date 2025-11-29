local tools = require("dko.tools")

tools.register({
  fts = { "html" },
  name = "prettier",
  efm = require("dko.tools.prettier").efm,
})

tools.register({
  name = "html",
  runner = "lspconfig",
})
