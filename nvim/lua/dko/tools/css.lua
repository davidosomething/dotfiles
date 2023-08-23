local tools = require("dko.tools")

tools.register({
  type = "lsp",
  require = "npm",
  name = "stylelint_lsp",
  runner = "lspconfig",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
    return function()
      require("lspconfig").stylelint_lsp.setup(middleware({
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
      }))
    end
  end,
})
