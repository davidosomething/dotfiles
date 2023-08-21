local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "actionlint",
  runner = "efm",
})

tools.register({
  type = "tool",
  require = "_",
  name = "yamlfmt",
  runner = "null_ls",
})

tools.register({
  type = "tool",
  require = "python",
  name = "yamllint",
  runner = "efm",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "ansiblels",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "docker_compose_language_service",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "yamlls",
})
