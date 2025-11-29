local tools = require("dko.tools")

tools.register({
  fts = { "sh" },
  name = "shellcheck",
  efm = function()
    ---@type EfmLinter
    return vim.tbl_extend(
      "force",
      -- https://github.com/creativenull/efmls-configs-nvim/blob/main/lua/efmls-configs/linters/shellcheck.lua
      require("efmls-configs.linters.shellcheck"),
      {
        lintSource = "efmls",
        rootMarkers = { ".shellcheckrc" },
      }
    )
  end,
})

tools.register({
  fts = { "sh" },
  name = "shfmt",
  efm = function()
    ---@type EfmFormatter
    return require("efmls-configs.formatters.shfmt")
  end,
})

-- this lsp just runs shellcheck and shfmt
-- tools.register({
--   runner = "lspconfig",
--   name = "bashls",
--   fts = { "bash", "sh" },
-- })
