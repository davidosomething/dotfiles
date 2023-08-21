local tools = require("dko.tools")

tools.register_tool({
  require = "python",
  name = "vint",
  runner = "efm",
})

tools.register_lsp({
  require = "npm",
  name = "vimls",
})
