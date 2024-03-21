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
})

-- python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  mason_type = "lsp",
  require = "python",
  name = "jedi_language_server",
  runner = "mason-lspconfig",
})

-- python lint and format from ruff
-- tools.register({
--   mason_type = "lsp",
--   require = "python",
--   name = "ruff_lsp",
--   runner = "mason-lspconfig",
-- })
