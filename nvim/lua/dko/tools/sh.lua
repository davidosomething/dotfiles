local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "_",
  name = "shellcheck",
  fts = { "sh" },
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
  mason_type = "tool",
  require = "_",
  name = "shfmt",
  fts = { "sh" },
  efm = function()
    ---@type EfmFormatter
    return require("efmls-configs.formatters.shfmt")
  end,
})
