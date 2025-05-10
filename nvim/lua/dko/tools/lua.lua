local tools = require("dko.tools")

tools.register({
  name = "selene",
  fts = { "lua" },
  mason_type = "tool",
  require = "_",
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
  mason_type = "tool",
  require = "_",
  name = "stylua",
  fts = { "lua" },
  efm = function()
    ---@type EfmFormatter
    return vim.tbl_extend("force", require("efmls-configs.formatters.stylua"), {
      rootMarkers = { "stylua.toml", ".stylua.toml", ".editorconfig" },
    })
  end,
})

tools.register({
  mason_type = "lsp",
  require = "_",
  name = "lua_ls",
  runner = "mason-lspconfig",
})
