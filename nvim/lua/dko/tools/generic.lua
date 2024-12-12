local tools = require("dko.tools")

-- use brew'ed tree-sitter since it will be properly compiled for M1 macs
if vim.env.DOTFILES_OS ~= "Darwin" then
  tools.register({
    mason_type = "tool",
    require = "_",
    name = "tree-sitter-cli",
  })
end

tools.register({
  mason_type = "lsp",
  require = "go",
  name = "efm",
  runner = "mason-lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      filetypes = require("dko.tools").get_efm_filetypes(),
      single_file_support = true,
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = { languages = require("dko.tools").get_efm_languages() },
    }
  end,
})
