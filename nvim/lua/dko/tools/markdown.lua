local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "markdownlint",
  efm = function()
    return {
      languages = { "markdown" },
      config = {
        lintCommand = "markdownlint --stdin",
        lintStdin = true,
      },
    }
  end,
})

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  runner = "efm",
  efm = function()
    return {
      languages = { "markdown" },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})
