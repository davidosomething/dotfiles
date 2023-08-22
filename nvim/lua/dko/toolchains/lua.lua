local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "selene",
  runner = "null_ls",
})

tools.register({
  type = "tool",
  require = "_",
  name = "stylua",
  runner = "efm",
  efm = function()
    return {
      languages = { "lua" },
      config = require("efmls-configs.formatters.stylua"),
    }
  end,
})

tools.register({
  type = "lsp",
  require = "_",
  name = "lua_ls",
})
