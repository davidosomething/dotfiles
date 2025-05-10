local tools = require("dko.tools")

local M = {}

tools.register({
  name = "prettier",
  mason_type = "tool",
  require = "npm",
  fts = require("dko.utils.jsts").fts,
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

-- jumping into classnames from jsx/tsx
-- tools.register({
--   name = "cssmodules_ls",
--   mason_type = "lsp",
--   require = "npm",
-- })

-- using coc-eslint
-- tools.register({
--   name = "eslint",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
-- })

-- using @yaegassy/coc-tailwindcss3
--"cssls" conflicts with tailwindcss
tools.register({
  name = "tailwindcss",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
})

-- tools.register({
--   name = "ts_ls",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
-- })

-- tools.register({
--   name = "vtsls",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
-- })

return M
