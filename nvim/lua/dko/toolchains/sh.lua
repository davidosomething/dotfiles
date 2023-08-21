local tools = require("dko.tools")

--no "bashls", -- prefer shellcheck, has code_actions and code inline

tools.register_tool({
  require = "_",
  name = "shellcheck",
  runner = { "efm", "bashls" },
})

tools.register_tool({
  require = "_",
  name = "shfmt",
  runner = "efm",
})
