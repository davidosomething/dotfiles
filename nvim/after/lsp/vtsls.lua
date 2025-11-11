local dkots = require("dko.utils.typescript")

--- importModuleSpecifier https://github.com/LazyVim/LazyVim/discussions/3623#discussioncomment-10089949
local importModuleSpecifier = "relative" -- "relative", "project-relative",

---@type lspconfig.Config
return {
  on_attach = function(client, bufnr)
    dkots.ts_ls.config.on_attach(client, bufnr)
    vim.keymap.set("n", "gd", function()
      dkots.go_to_source_definition("vtsls", "typescript.goToSourceDefinition")
    end, { desc = "vtsls typescript.goToSourceDefinition", buffer = true })
  end,
  handlers = dkots.ts_ls.config.handlers,
  settings = {
    javascript = {
      preferences = {
        importModuleSpecifier = importModuleSpecifier,
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = {
          --- @type 'none' | 'literals' | 'all'
          enabled = "all",
        },
        parameterTypes = {
          enabled = false, --- use K
        },
        variableTypes = {
          enabled = false, --- use K
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = false, --- use K
        },
        enumMemberValues = {
          enabled = true,
        },
      },
      preferences = {
        importModuleSpecifier = importModuleSpecifier,
      },
    },
    vtsls = {
      --- @see https://github.com/yioneko/nvim-vtsls/blob/60b493e641d3674c030c660cabe7a2a3f7a914be/lsp/vtsls.lua#L27C1-L29C7
      enableMoveToFileCodeAction = false,
    },
  },
}
