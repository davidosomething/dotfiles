local tools = require("dko.tools")

tools.register({
  name = "dockerls",
  mason_type = "lsp",
  runner = "mason-lspconfig",
  require = "npm",
})

tools.register({
  name = "hadolint",
  fts = { "Dockerfile" },
  mason_type = "tool",
  require = "_",
  efm = function()
    ---@type EfmLinter
    return require("efmls-configs.linters.hadolint")
  end,
})

-- note: "docker_compose_language_service" is yaml!
