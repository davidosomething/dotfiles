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
})
