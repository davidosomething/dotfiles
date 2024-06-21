local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "npm",
  name = "markdownlint",
  fts = { "markdown" },
  efm = function()
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.markdownlint"),
      { lintSource = "efm" }
    )
  end,
})

-- code actions for link completion
tools.register({
  mason_type = "lsp",
  name = "marksman",
  fts = { "markdown" },
  runner = "mason-lspconfig",
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

-- Vale not working
--
-- tools.register({
--   mason_type = "tool",
--   name = "vale",
--   fts = { "markdown" },
-- })
--
-- -- vale_ls needs vale cli tool!
-- tools.register({
--   mason_type = "lsp",
--   name = "vale_ls",
--   fts = { "markdown" },
--   runner = "mason-lspconfig",
-- })
