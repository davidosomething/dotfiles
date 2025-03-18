---Apply stylua.toml spacing if no editorconfig
if not vim.b.editorconfig or vim.tbl_isempty(vim.b.editorconfig) then
  require("dko.editing").from_stylua_toml()
end

-- In 0.11 it's supposed to jump to module in same repo/rtp/package path, but not
-- quite the way I want it.
require("dko.mappings").ft.lua()
