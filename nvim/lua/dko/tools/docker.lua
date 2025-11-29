local tools = require("dko.tools")

--- https://github.com/rcjsuen/dockerfile-language-server
tools.register({
  name = "dockerls",
  runner = "lspconfig",
})

tools.register({
  fts = { "Dockerfile" },
  name = "hadolint",
  efm = function()
    ---@type EfmLinter
    return require("efmls-configs.linters.hadolint")
  end,
})

-- note: "docker_compose_language_service" is yaml!
