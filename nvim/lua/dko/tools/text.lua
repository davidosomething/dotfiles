local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "harper_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        ["harper-ls"] = {
          userDictPath = os.getenv("DOTFILES") .. "/harper-ls/dictionary.txt",
          codeActions = {
            ForceStable = true,
          },
        },
      },
    }
  end,
})
