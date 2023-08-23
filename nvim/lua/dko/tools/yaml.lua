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

-- https://www.npmjs.com/package/@microsoft/compose-language-service
tools.register({
  type = "lsp",
  require = "npm",
  name = "docker_compose_language_service",
  runner = "lspconfig",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
    return function()
      require("lspconfig").docker_compose_language_service.setup(middleware({
        on_attach = function(client)
          -- yamlfmt or NOTHING
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      }))
    end
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "yamlls",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
    return function()
      require("lspconfig").yamlls.setup(middleware({
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
      }))
    end
  end,
})
