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
})

tools.register({
  type = "lsp",
  require = "_",
  name = "lua_ls",
})
