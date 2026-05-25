local tools = require("dko.tools")

-- ===========================================================================
-- GitHub Workflows/Actions
-- this is a wrapper, don't need it any more
-- tools.register({ name = "gh_actions_ls", runner = "lspconfig" })
-- this is upstream, custom config in ../../../lsp/actionsls.lua
tools.register({
  name = "actionsls",
  runner = "lspconfig",
})

tools.register({
  name = "actionlint",
  fts = { "yaml.ghactions" },
  efm = function()
    ---@type EfmLinter
    return require("efmls-configs.linters.actionlint")
  end,
})
-- ===========================================================================

tools.register({
  name = "yamlfmt",
  fts = { "yaml", "yaml.ghactions", "yaml.docker-compose" },
  efm = function()
    return {
      formatCanRange = false,
      formatCommand = "yamlfmt -",
      formatStdin = true,
      rootMarkers = {
        ".yamlfmt",
        "yamlfmt.yml",
        "yamlfmt.yaml",
        ".yamlfmt.yaml",
        ".yamlfmt.yml",
      },
    }
  end,
})

-- yamlls linting is disabled in favor of this
tools.register({
  name = "yamllint",
  fts = { "yaml", "yaml.ghactions", "yaml.docker-compose" },
  efm = function()
    return vim.tbl_extend("force", require("efmls-configs.linters.yamllint"), {
      lintAfterOpen = true,
      lintIgnoreExitCode = true,
      lintSource = "efmls",
      prefix = "yamllint",
      rootMarkers = {
        ".yamllint",
        ".yamllint.yaml",
        ".yamllint.yml",
      },
    })
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
