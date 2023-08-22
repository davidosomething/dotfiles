local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  runner = "efm",
  efm = function()
    return {
      languages = { "json" },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "jsonls",
})
