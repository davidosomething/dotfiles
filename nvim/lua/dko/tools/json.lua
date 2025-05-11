local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "json", "jsonc" },
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

-- Using coc-json instead
-- not used for formatting - prefer prettier since it does one-line arrays
-- when they fit
-- tools.register({
--   mason_type = "lsp",
--   require = "npm",
--   name = "jsonls",
--   runner = "mason-lspconfig",
-- })
