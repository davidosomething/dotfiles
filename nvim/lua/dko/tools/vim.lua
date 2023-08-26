local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "python",
  name = "vint",
  fts = { "vim" },
  efm = function()
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.vint"),
      { lintSource = "efmls", prefix = "vint" }
    )
  end,
})

tools.register({
  mason_type = "lsp",
  require = "npm",
  name = "vimls",
  runner = "mason-lspconfig",
})
