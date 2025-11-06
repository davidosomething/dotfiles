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

-- type checker, go-to definition support
tools.register({
  name = "basedpyright",
  -- installed via mise now (using uvx)
  require = "basedpyright",
  runner = "lspconfig",
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
  })
end
