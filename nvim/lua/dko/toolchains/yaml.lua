local tools = require("dko.tools")

tools.register_tool({
  require = "_",
  name = "actionlint",
  runner = "efm",
})

tools.register_tool({
  require = "_",
  name = "yamlfmt",
  runner = "null_ls",
})

tools.register_tool({
  require = "python",
  name = "yamllint",
  runner = "efm",
})

tools.register_lsp({
  require = "npm",
  name = "ansiblels",
})

tools.register_lsp({
  require = "npm",
  name = "docker_compose_language_service",
})

tools.register_lsp({
  require = "npm",
  name = "yamlls",
})
