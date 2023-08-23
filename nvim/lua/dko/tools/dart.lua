local tools = require("dko.tools")

tools.register({
  type = "lsp",
  name = "dartls",
  install = false,
  runner = "lspconfig",
  lspconfig = function()
    return {
      settings = {
        dart = { showTodos = false },
      },
    }
  end,
})
