return {
  settings = {
    ["harper-ls"] = {
      codeActions = {
        ForceStable = true,
      },
      linters = {
        Dashes = false,
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
