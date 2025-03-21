local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "harper_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        ["harper-ls"] = {
          codeActions = {
            ForceStable = true,
          },
          linters = {
            LongSentences = false,
            Matcher = false, -- e.g. deps to dependencies
            SentenceCapitalization = false,
            Spaces = false,
            SpellCheck = false,
            ToDoHyphen = false,
          },
          userDictPath = os.getenv("DOTFILES") .. "/harper-ls/dictionary.txt",
        },
      },
    }
  end,
})
