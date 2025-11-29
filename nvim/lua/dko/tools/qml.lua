local tools = require("dko.tools")

tools.register({
  fts = { "qml" },
  name = "qmlformat",
  efm = function()
    return {
      formatCommand = "qmlformat --inplace ${INPUT}",
      formatStdin = false,
    }
  end,
})

tools.register({
  fts = { "qml" },
  name = "qmllint",
  efm = function()
    return {
      lintCommand = "qmllint ${INPUT}",
      lintSource = "efm",
      lintStdin = false,
      prefix = "qmllint",
    }
  end,
})
