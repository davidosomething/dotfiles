local dkotools = require("dko.tools")

-- use brew'ed tree-sitter since it will be properly compiled for M1 macs
if vim.env.DOTFILES_OS ~= "Darwin" then
  dkotools.register({
    mason_type = "tool",
    require = "_",
    name = "tree-sitter-cli",
  })
end

dkotools.register({
  mason_type = "lsp",
  require = "go",
  name = "efm",
  runner = "mason-lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      filetypes = dkotools.get_efm_filetypes(),
      single_file_support = true,
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = { languages = dkotools.get_efm_languages() },
    }
  end,
})
