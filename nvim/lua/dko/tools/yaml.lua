local tools = require("dko.tools")

tools.register({
  fts = { "yaml" },
  name = "yamlfmt",
  efm = function()
    return {
      formatCanRange = false,
      formatCommand = "yamlfmt -",
      formatStdin = true,
      rootMarkers = { ".yamlfmt" },
    }
  end,
})

-- yamlls linting is disabled in favor of this
tools.register({
  name = "yamllint",
  fts = { "yaml" },
  efm = function()
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.yamllint"),
      { lintSource = "efmls", prefix = "yamllint" }
    )
  end,
})

-- https://www.npmjs.com/package/@microsoft/compose-language-service
tools.register({
  name = "docker_compose_language_service",
  runner = "lspconfig",
})

tools.register({
  name = "yamlls",
  runner = "lspconfig",
})
