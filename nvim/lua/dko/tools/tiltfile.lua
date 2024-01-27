local tools = require("dko.tools")

tools.register({
  name = "tilt_ls",
  runner = "lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {}
  end,
})
