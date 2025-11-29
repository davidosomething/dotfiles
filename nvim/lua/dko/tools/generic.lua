local dkotools = require("dko.tools")

dkotools.register({
  mason_type = "lsp",
  name = "efm",
  require = "go",
  runner = "mason-lspconfig",
})

dkotools.register({
  name = "codebook",
  require = "cargo",
  runner = "lspconfig",
})
