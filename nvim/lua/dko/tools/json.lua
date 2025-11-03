local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "json", "jsonc" },
  efm = require("dko.tools.prettier").efm,
})

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "biome",
  fts = { "json", "jsonc" },
  efm = require("dko.tools.biome"),
})

if not require("dko.settings").get("coc.enabled") then
  -- not used for formatting - prefer prettier since it does one-line arrays
  -- when they fit
  tools.register({
    mason_type = "lsp",
    require = "npm",
    name = "jsonls",
    runner = "mason-lspconfig",
  })
end
