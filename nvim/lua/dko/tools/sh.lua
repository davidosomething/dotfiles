local tools = require("dko.tools")

--no "bashls", -- prefer shellcheck, has code_actions and code inline

tools.register({
  type = "tool",
  require = "_",
  name = "shellcheck",
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
  efm = function()
    return {
      languages = { "sh" },
      config = require("efmls-configs.formatters.shfmt"),
    }
  end,
})
