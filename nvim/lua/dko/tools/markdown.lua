local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "markdownlint",
  fts = { "markdown" },
  efm = function()
    return {
      lintCommand = "markdownlint --stdin",
      lintIgnoreExitCode = true,
      lintSource = "efm",
      lintStdin = true,
      prefix = "markdownlint",
    }
  end,
})

-- needs temp file to handle
-- tools.register({
--   mason_type = "tool",
--   require = "npm",
--   name = "markdownlint",
--   fts = { "markdown" },
--   efm = function()
--     return {
--       formatCommand = "markdownlint --fix --quiet ${INPUT}",
--       formatStdin = false,
--     }
--   end,
-- })

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "prettier",
  fts = { "markdown" },
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})
