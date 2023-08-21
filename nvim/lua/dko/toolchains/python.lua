local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "python",
  name = "black",
  runner = "efm",
})

tools.register({
  type = "tool",
  require = "python",
  name = "isort",
  runner = "null-ls",
})

-- python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  type = "lsp",
  require = "python",
  name = "jedi_language_server",
})

-- python lint and format from ruff
tools.register({
  type = "lsp",
  require = "python",
  name = "ruff_lsp",
})
