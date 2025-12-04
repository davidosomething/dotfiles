local dkots = require("dko.utils.typescript")

--- importModuleSpecifier https://github.com/LazyVim/LazyVim/discussions/3623#discussioncomment-10089949
local defaultImportModuleSpecifier = "non-relative" -- "relative", "project-relative",

---@type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
    dkots.ts_ls.config.on_attach(client, bufnr)
    require("dko.mappings").bind_vtsls()

    -- Set import module specifier based on tsconfig path aliases
    local uses_aliases = dkots.uses_path_aliases()
    local specifier = uses_aliases and "non-relative" or "project-relative" --[[@as importModuleSpecifier]]
    require("dko.lsp").set_import_module_specifier(client, specifier)
  end,
  handlers = dkots.ts_ls.config.handlers,
  settings = {
    javascript = {
      preferences = {
        importModuleSpecifier = defaultImportModuleSpecifier,
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
        importModuleSpecifier = defaultImportModuleSpecifier,
        autoImportSpecifierExcludeRegexes = {
          --- Exclude imports from lucide-react that do not have the word Icon
          -- "(?!.*Icon).*lucide-react",
          "(?!.*Button).*react-day-picker",
        },
      },
    },
    vtsls = {
      --- @see https://github.com/yioneko/nvim-vtsls/blob/60b493e641d3674c030c660cabe7a2a3f7a914be/lsp/vtsls.lua#L27C1-L29C7
      enableMoveToFileCodeAction = false,
    },
  },
}
