local tools = require("dko.tools")

tools.register({
  name = "qmlformat",
  fts = { "qml" },
  efm = function()
    return {
      formatCommand = "qmlformat --inplace ${INPUT}",
      formatStdin = false,
    }
  end,
})

tools.register({
  name = "qmllint",
  fts = { "qml" },
  efm = function()
    return {
      lintCommand = "qmllint ${INPUT}",
      lintSource = "efm",
      lintStdin = false,
      prefix = "qmllint",
    }
  end,
})
