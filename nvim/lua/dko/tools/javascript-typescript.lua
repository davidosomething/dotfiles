local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  runner = "efm",
  efm = function()
    return {
      languages = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})

-- jumping into classnames from jsx/tsx
tools.register({
  type = "lsp",
  require = "npm",
  name = "cssmodules_ls",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "eslint",
})

--"cssls", -- conflicts with tailwindcss
tools.register({
  type = "lsp",
  require = "npm",
  name = "tailwindcss",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "tsserver",
})
