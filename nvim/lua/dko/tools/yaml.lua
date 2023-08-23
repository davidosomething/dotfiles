local tools = require("dko.tools")

-- yamlls linting is disabled in favor of this
tools.register({
  type = "tool",
  require = "python",
  name = "yamllint",
  runner = "efm",
  efm = function()
    return {
      languages = { "yaml" },
      config = require("efmls-configs.linters.yamllint"),
    }
  end,
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
