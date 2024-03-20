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
  -- https://github.com/mason-org/mason-registry/pull/4996
  -- @TODO switch to lsp https://github.com/williamboman/mason-lspconfig.nvim/pull/379/files
  mason_type = "tool", -- "lsp",
  require = "python",
  name = "basedpyright",
  -- runner = "mason-lspconfig",
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
