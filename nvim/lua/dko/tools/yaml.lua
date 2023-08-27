local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "go",
  name = "yamlfmt",
  fts = { "yaml" },
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
  mason_type = "tool",
  require = "python",
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

tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "ansiblels",
})

-- https://www.npmjs.com/package/@microsoft/compose-language-service
tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "docker_compose_language_service",
  runner = "mason-lspconfig",
})

tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "yamlls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        yaml = {
          format = { enable = true },
          validate = { enable = true }, -- prefer yamllint
          -- disable built-in fetch schemas, prefer schemastore.nvim
          schemaStore = { enable = false },
          schemas = require("schemastore").yaml.schemas({
            ignore = { "Cheatsheets" },
          }),
        },
      },
    }
  end,
})
