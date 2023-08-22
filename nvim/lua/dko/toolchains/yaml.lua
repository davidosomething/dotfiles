local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "actionlint",
  runner = "null_ls",

  -- @TODO still getting a false positive match on this...
  -- rootMarkers and requireMarker are suppsoed to narrow to files in .github/ only
  -- @SEE https://github.com/mattn/efm-langserver/issues/257
  -- efm = function()
  --   return {
  --     language = "yaml",
  --     config = require("efmls-configs.linters.actionlint"),
  --   }
  -- end,
})

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
