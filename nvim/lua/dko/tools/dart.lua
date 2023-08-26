local tools = require("dko.tools")

tools.register({
  name = "dartls",
  runner = "lspconfig",
  lspconfig = function()
    return {
      settings = {
        dart = { showTodos = false },
      },
    }
  end,
})
