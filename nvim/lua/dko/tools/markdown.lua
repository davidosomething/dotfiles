local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "markdownlint",
  efm = function()
    return {
      languages = { "markdown" },
      config = {
        lintCommand = "markdownlint --stdin",
        lintSource = "efm",
        lintStdin = true,
        prefix = "markdownlint",
      },
    }
  end,
})

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  efm = function()
    return {
      languages = { "markdown" },
      config = vim.tbl_extend(
        "force",
        require("efmls-configs.formatters.prettier"),
        { lintSource = "efmls", prefix = "prettier" }
      ),
    }
  end,
})
