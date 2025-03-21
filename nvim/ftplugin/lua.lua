---Apply stylua.toml spacing if no editorconfig
if not vim.b.editorconfig or vim.tbl_isempty(vim.b.editorconfig) then
  require("dko.editing").from_stylua_toml()
end
