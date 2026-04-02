--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/efm.lua

local configs_by_ft = require("dko.tools").config_with_efm_by_ft
local filetypes = vim.tbl_keys(configs_by_ft)
local languages = vim.tbl_map(function(configs)
  return vim.tbl_map(function(c)
    return c.efm()
  end, configs)
end, configs_by_ft)

---@type vim.lsp.Config
return {
  filetypes = filetypes,
  single_file_support = true,
  init_options = {
    codeAction = true,
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = { languages = languages },
}
