local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "qmlformat",
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
