local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  runner = "mason-lspconfig",
  require = "npm",
  name = "dockerls",
})

-- note: "docker_compose_language_service" is yaml!
