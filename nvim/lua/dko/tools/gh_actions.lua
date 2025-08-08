local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  fts = { "yaml" },
  name = "gh_actions_ls",
  runner = "lspconfig",
})
