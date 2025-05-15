local dkotools = require("dko.tools")

---@type lspconfig.Config
return {
  filetypes = vim.tbl_keys(dkotools.efm_filetypes),
  single_file_support = true,
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = { languages = dkotools.get_efm_languages() },
}
