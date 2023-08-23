local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "selene",
  efm = function()
    return {
      languages = { "lua" },
      config = {
        lintCommand = "selene --display-style quiet -",
        lintSource = "selene",
        lintStdin = true,
        rootMarkers = {"selene.toml" }
      },
    }
  end,
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
