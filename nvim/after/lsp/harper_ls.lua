---@type vim.lsp.Config
return {
  filetypes = {
    "gitcommit",
    "md",
    "mdx",
  },
  settings = {
    ["harper-ls"] = {
      codeActions = {
        ForceStable = true,
      },
      linters = {
        Dashes = false,
        ExpandDependencies = false,
        LongSentences = false,
        Matcher = false, -- e.g. deps to dependencies
        SentenceCapitalization = false,
        Spaces = false,
        SpellCheck = false,
        ToDoHyphen = false,
      },
    },
  },
}
