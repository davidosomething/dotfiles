local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "_",
  name = "tree-sitter-cli",
})

tools.register({
  type = "lsp",
  require = "go",
  name = "efm",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
    local efm_languages = require("dko.tools").get_efm_languages()
    local efm_filetypes = vim.tbl_keys(efm_languages)
    return function()
      require("lspconfig").efm.setup(middleware({
        filetypes = efm_filetypes,
        single_file_support = true,
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
        settings = { languages = efm_languages },
      }))
    end
  end,
})
