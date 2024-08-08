local tools = require("dko.tools")

-- just use ruff, it's >99.99% compatible with black
-- @TODO mac+mise having trouble installing
if vim.fn.has("macunix") == 1 then
  tools.register({
    mason_type = "tool",
    require = "python",
    name = "black",
    fts = { "python" },
    efm = function()
      return require("efmls-configs.formatters.black")
    end,
  })
end

-- ruff can also sort, but does it in two passes,
-- see https://docs.astral.sh/ruff/formatter/#sorting-imports
-- use isort for now
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

-- type checker, go to def
tools.register({
  mason_type = "lsp",
  require = "python",
  name = "basedpyright",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- prefer ruff or isort
          typeCheckingMode = "standard",
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

-- syntax checker, python hover and some diagnostics from jedi
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
-- @TODO mac+mise having trouble installing
if vim.fn.has("macunix") == 0 then
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
end
