local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "harper_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        ["harper-ls"] = {
          linters = {
            spell_check = false,
            spelled_numbers = false,
            an_a = true,
            sentence_capitalization = false,
            unclosed_quotes = true,
            wrong_quotes = false,
            long_sentences = false,
            repeated_words = true,
            spaces = false,
            matcher = true,
            correct_number_suffix = true,
            number_suffix_capitalization = true,
            multiple_sequential_pronouns = true,
          },
        },
      },
    }
  end,
})
