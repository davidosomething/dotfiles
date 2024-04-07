local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "python",
  name = "black",
  fts = { "python" },
  efm = function()
    return require("efmls-configs.formatters.black")
  end,
})

tools.register({
  mason_type = "tool",
  require = "python",
  name = "isort",
  fts = { "python" },
  efm = function()
    return {
      formatCommand = "isort --profile black --quiet -",
      formatStdin = true,
    }
  end,
})

tools.register({
  mason_type = "lsp",
  require = "python",
  name = "basedpyright",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    }
  end,
})

-- python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  mason_type = "lsp",
  require = "python",
  name = "jedi_language_server",
  runner = "mason-lspconfig",
})

-- python lint and format from ruff using "ruff server", configuration
-- (newer than ruff-lsp standalone project)
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ruff.lua
tools.register({
  name = "ruff",
  mason_type = "lsp",
  require = "python",
  lspconfig = function()
    return {
      ---note: local on_attach happens AFTER autocmd LspAttach
      on_attach = function(client)
        -- basedpyright instead
        client.server_capabilities.hoverProvider = false
      end,
    }
  end,
})
