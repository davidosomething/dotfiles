local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  efm = function()
    return {
      languages = { "html" },
      config = vim.tbl_extend(
        "force",
        require("efmls-configs.formatters.prettier"),
        { lintSource = "efmls", prefix = "prettier" }
      ),
    }
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "html",
  runner = "mason-lspconfig",
})
