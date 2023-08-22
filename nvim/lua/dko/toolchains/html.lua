local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  runner = "efm",
  efm = function()
    return {
      languages = { "html" },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})
