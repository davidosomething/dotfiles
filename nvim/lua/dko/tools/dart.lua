local tools = require("dko.tools")

tools.register({
  name = "dartls",
  require = "dart",
  runner = "lspconfig",
})
