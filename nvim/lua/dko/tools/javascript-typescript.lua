local tools = require("dko.tools")
-- local dkots = require("dko.utils.typescript")

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

-- Provides textDocument/documentColor that nvim-highlight-colors can use
-- Trigger tailwind completion manually using <C-Space> since coc is probably
-- handling default completion using @yaegassy/coc-tailwindcss3
--"cssls", -- conflicts with tailwindcss
tools.register({
  name = "tailwindcss",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
})

if not require("dko.settings").get("coc.enabled") then
  tools.register({
    name = "eslint",
    mason_type = "lsp",
    require = "npm",
    runner = "mason-lspconfig",
  })

  tools.register({
    name = "vtsls",
    mason_type = "lsp",
    require = "npm",
    runner = "mason-lspconfig",
  })

  -- mason-lspconfig ts_ls config
  -- tools.register({
  --   name = "ts_ls",
  --   mason_type = "lsp",
  --   require = "npm",
  --   runner = "mason-lspconfig",
  --   ---
  --   ts_ls binary only for "pmizio/typescript-tools.nvim", add:
  --   skip_init = true,
  --   ---
  -- })
end

return M
