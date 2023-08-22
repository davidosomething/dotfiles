local tools = require("dko.tools")

--no "bashls", -- prefer shellcheck, has code_actions and code inline

tools.register({
  type = "tool",
  require = "_",
  name = "shellcheck",
  runner = { "efm", "bashls" },
  efm = function()
    return {
      languages = { "sh" },
      config = require("efmls-configs.linters.shellcheck"),
    }
  end,
})

tools.register({
  type = "tool",
  require = "_",
  name = "shfmt",
  runner = "efm",
  efm = function()
    return {
      languages = { "sh" },
      config = require("efmls-configs.formatters.shfmt"),
    }
  end,
})
