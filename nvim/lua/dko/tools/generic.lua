local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "tree-sitter-cli",
})

tools.register({
  type = "lsp",
  require = "go",
  name = "efm",
})
