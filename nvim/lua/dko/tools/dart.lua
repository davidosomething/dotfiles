local tools = require("dko.tools")

tools.register({
  name = "dartls",
  runner = "lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      settings = {
        dart = { showTodos = false },
      },
    }
  end,
})
