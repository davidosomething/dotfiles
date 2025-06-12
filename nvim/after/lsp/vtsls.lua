local dkots = require("dko.utils.typescript")

---@type lspconfig.Config
return {
  on_attach = dkots.ts_ls.config.on_attach,
  handlers = dkots.ts_ls.config.handlers,
  settings = {
    javascript = {
      preferences = {
        -- importModuleSpecifier https://github.com/LazyVim/LazyVim/discussions/3623#discussioncomment-10089949
        importModuleSpecifier = "non-relative", -- "project-relative",
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      preferences = {
        importModuleSpecifier = "non-relative", -- "project-relative",
      },
    },
  },
}
