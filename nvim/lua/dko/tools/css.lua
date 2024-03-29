local tools = require("dko.tools")

tools.register({
  name = "stylelint_lsp",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      -- Disable on some filetypes
      -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/stylelint_lsp.lua
      filetypes = {
        "css",
        "less",
        "scss",
        "sugarss",
        -- 'vue',
        "wxss",
        -- 'javascript',
        -- 'javascriptreact',
        -- 'typescript',
        -- 'typescriptreact',
      },
    }
  end,
})
