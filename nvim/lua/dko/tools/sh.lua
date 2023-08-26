local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "shellcheck",
  efm = function()
    return {
      languages = { "sh" },
      -- @TODO https://github.com/creativenull/efmls-configs-nvim/pull/44
      config = vim.tbl_extend(
        "force",
        require("efmls-configs.linters.shellcheck"),
        {
          lintIgnoreExitCode = true,
          lintSource = "efmls",
          rootMarkers = { ".shellcheckrc" },
        }
      ),
    }
  end,
})

tools.register({
  type = "tool",
  require = "_",
  name = "shfmt",
  efm = function()
    return {
      languages = { "sh" },
      config = require("efmls-configs.formatters.shfmt"),
    }
  end,
})
