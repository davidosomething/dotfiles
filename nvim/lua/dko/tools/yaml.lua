local tools = require("dko.tools")

-- yamlls linting is disabled in favor of this
tools.register({
  type = "tool",
  require = "python",
  name = "yamllint",
  efm = function()
    return {
      languages = { "yaml" },
      config = vim.tbl_extend(
        "force",
        require("efmls-configs.linters.yamllint"),
        { lintSource = "efmls", prefix = "yamllint" }
      ),
    }
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "ansiblels",
})

-- https://www.npmjs.com/package/@microsoft/compose-language-service
tools.register({
  type = "lsp",
  require = "npm",
  name = "docker_compose_language_service",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      on_attach = function(client)
        -- yamlfmt or NOTHING
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    }
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "yamlls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        yaml = {
          format = { enable = false }, -- prefer stylua
          validate = { enable = false }, -- prefer yamllint
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
