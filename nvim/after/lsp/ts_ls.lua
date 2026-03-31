local dkots = require("dko.utils.typescript")

---@type vim.lsp.Config
return {
  on_attach = dkots.ts_ls.config.on_attach,
  handlers = dkots.ts_ls.config.handlers,
  ---@type lspconfig.settings.ts_ls
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
