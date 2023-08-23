local tools = require("dko.tools")

tools.register({
  type = "lsp",
  name = "tilt_ls",
  install = false,
  runner = "lspconfig",
  lspconfig = function()
    return {}
  end,
})
