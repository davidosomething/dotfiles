local dkotools = require("dko.tools")
-- local dkots = require("dko.utils.typescript")

local M = {}

dkotools.register({
  fts = require("dko.utils.jsts").fts,
  name = "prettier",
  efm = require("dko.tools.prettier").efm,
})

dkotools.register({
  fts = require("dko.utils.jsts").fts,
  name = "biome",
  efm = require("dko.tools.biome"),
})

-- jumping into classnames from jsx/tsx
-- dkotools.register({
--   name = "cssmodules_ls",
-- })

-- Provides textDocument/documentColor that nvim-highlight-colors can use
-- Trigger tailwind completion manually using <C-Space> since coc is probably
-- handling default completion using @yaegassy/coc-tailwindcss3
--"cssls", -- conflicts with tailwindcss
dkotools.register({
  name = "tailwindcss",
  runner = "lspconfig",
})

if not require("dko.settings").get("coc.enabled") then
  dkotools.register({
    name = "eslint",
    runner = "lspconfig",
  })

  dkotools.register({
    name = "vtsls",
    runner = "lspconfig",
  })

  -- dkotools.register({
  --   name = "ts_ls",
  --   runner = "lspconfig",
  --   ---
  --   ts_ls binary only for "pmizio/typescript-tools.nvim", add:
  --   skip_init = true,
  --   ---
  -- })
end

return M
