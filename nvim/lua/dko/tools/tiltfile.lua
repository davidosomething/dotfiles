local tools = require("dko.tools")

tools.register({
  name = "tilt_ls",
  runner = "lspconfig",
  lspconfig = function()
    return {}
  end,
})
