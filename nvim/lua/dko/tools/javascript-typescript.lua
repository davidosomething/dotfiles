local tools = require("dko.tools")
-- local dkots = require("dko.utils.typescript")

local M = {}

tools.register({
  fts = require("dko.utils.jsts").fts,
  name = "prettier",
  efm = require("dko.tools.prettier").efm,
})

tools.register({
  fts = require("dko.utils.jsts").fts,
  name = "biome",
  efm = require("dko.tools.biome"),
})

-- jumping into classnames from jsx/tsx
-- tools.register({
--   name = "cssmodules_ls",
-- })

-- Provides textDocument/documentColor that nvim-highlight-colors can use
-- Trigger tailwind completion manually using <C-Space> since coc is probably
-- handling default completion using @yaegassy/coc-tailwindcss3
--"cssls", -- conflicts with tailwindcss
tools.register({
  name = "tailwindcss",
  runner = "lspconfig",
})

if not require("dko.settings").get("coc.enabled") then
  tools.register({
    name = "eslint",
    runner = "lspconfig",
  })

  tools.register({
    name = "vtsls",
    runner = "lspconfig",
  })

  -- tools.register({
  --   name = "ts_ls",
  --   runner = "lspconfig",
  --   ---
  --   ts_ls binary only for "pmizio/typescript-tools.nvim", add:
  --   skip_init = true,
  --   ---
  -- })
end

return M
