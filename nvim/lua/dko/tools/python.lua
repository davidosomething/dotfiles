local tools = require("dko.tools")

-- just use ruff, it's >99.99% compatible with black
-- @TODO mac+mise having trouble installing
-- if vim.fn.has("macunix") == 1 then
--   tools.register({
--     fts = { "python" },
--     name = "black",
--     efm = function()
--       return require("efmls-configs.formatters.black")
--     end,
--   })
-- end

-- ruff can also sort, but does it in two passes,
-- see https://docs.astral.sh/ruff/formatter/#sorting-imports
-- use isort for now
tools.register({
  fts = { "python" },
  name = "isort",
  efm = function()
    return {
      formatCommand = "isort --profile black --quiet -",
      formatStdin = true,
    }
  end,
})

-- type checker, go-to definition support
tools.register({
  name = "basedpyright",
  runner = "lspconfig",
})

-- syntax checker, python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  name = "jedi_language_server",
  runner = "lspconfig",
})

-- python lint and format from ruff using "ruff server", configuration
-- (newer than ruff-lsp standalone project)
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ruff.lua
tools.register({
  name = "ruff",
  runner = "lspconfig",
})
