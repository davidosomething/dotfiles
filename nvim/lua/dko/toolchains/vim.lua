local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "python",
  name = "vint",
  runner = "efm",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "vimls",
})
