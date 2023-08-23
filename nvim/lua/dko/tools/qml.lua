local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "qmlformat",
  install = false,
  efm = function()
    return {
      languages = { "qml" },
      config = {
        formatCommand = "qmlformat --inplace ${INPUT}",
        formatStdin = false,
      },
    }
  end,
})

tools.register({
  type = "tool",
  require = "_",
  name = "qmllint",
  install = false,
  efm = function()
    return {
      languages = { "qml" },
      config = {
        lintCommand = "qmllint ${INPUT}",
        lintStdin = false,
      },
    }
  end,
})
