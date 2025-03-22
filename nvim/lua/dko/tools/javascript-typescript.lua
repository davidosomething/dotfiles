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
--
--   lspconfig = function()
--     ---@type lspconfig.Config
--     return {
--       --- Use :LspStart cssmodules_ls to start this
--       autostart = false,
--
--       ---note: local on_attach happens AFTER autocmd LspAttach
--       on_attach = function(client)
--         -- https://github.com/davidosomething/dotfiles/issues/521
--         -- https://github.com/antonk52/cssmodules-language-server#neovim
--         -- avoid accepting `definitionProvider` responses from this LSP
--         client.server_capabilities.definitionProvider = false
--       end,
--     }
--   end,
-- })

-- using coc-eslint
-- tools.register({
--   name = "eslint",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
-- })

--"cssls", -- conflicts with tailwindcss
tools.register({
  name = "tailwindcss",
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
--   lspconfig = function()
--    return dkots.ts_ls.config
--   end,
-- })

-- tools.register({
--   name = "vtsls",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
--   lspconfig = function()
--     return {
--       on_attach = dkots.ts_ls.config.on_attach,
--       handlers = dkots.ts_ls.config.handlers,
--
--       -- importModuleSpecifier https://github.com/LazyVim/LazyVim/discussions/3623#discussioncomment-10089949
--       settings = {
--         javascript = {
--           preferences = {
--             importModuleSpecifier = "non-relative", -- "project-relative",
--           },
--         },
--         typescript = {
--           preferences = {
--             importModuleSpecifier = "non-relative", -- "project-relative",
--           },
--         },
--       },
--     }
--   end,
-- })

-- ts_ls with no integration, used for "pmizio/typescript-tools.nvim"
-- tools.register({
--   name = "ts_ls",
--   mason_type = "lsp",
--   require = "npm",
--   runner = "mason-lspconfig",
--   skip_init = true,
-- })

return M
