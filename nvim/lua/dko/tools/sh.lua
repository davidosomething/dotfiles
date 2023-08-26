local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "_",
  name = "shellcheck",
  fts = { "sh" },
  efm = function()
    -- @TODO https://github.com/creativenull/efmls-configs-nvim/pull/44
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.shellcheck"),
      {
        lintIgnoreExitCode = true,
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
    return require("efmls-configs.formatters.shfmt")
  end,
})
