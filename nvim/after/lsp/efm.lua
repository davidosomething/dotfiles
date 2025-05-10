local dkotools = require("dko.tools")

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
