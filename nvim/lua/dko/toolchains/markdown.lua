local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "markdownlint",
  runner = "null-ls",
})
