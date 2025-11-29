local tools = require("dko.tools")

tools.register({
  fts = { "lua" },
  name = "selene",
  efm = function()
    ---@type EfmLinter
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.selene"),
      { lintSource = "efmls" }
    )
  end,
})

tools.register({
  fts = { "lua" },
  name = "stylua",
  efm = function()
    ---@type EfmFormatter
    return vim.tbl_extend("force", require("efmls-configs.formatters.stylua"), {
      rootMarkers = { "stylua.toml", ".stylua.toml", ".editorconfig" },
    })
  end,
})

tools.register({
  name = "lua_ls",
  runner = "lspconfig",
})
