local tools = require("dko.tools")

tools.register_tool({
  require = "_",
  name = "selene",
  runner = "null_ls",
})

tools.register_tool({
  require = "_",
  name = "stylua",
  runner = "efm",
})

tools.register_lsp({
  require = "_",
  name = "lua_ls",
})
