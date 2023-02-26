-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.mapleader = " "

vim.g.loaded_node_provider = false
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
vim.g.loaded_python_provider = false -- disable python 2

-- Skips if python is not installed in a pyenv virtualenv
-- python 3
local py3 = require("dko.utils.find_exists")({
  "$PYENV_ROOT/versions/neovim3/bin/python",
  "$ASDF_DIR/shims/python",
  "/usr/bin/python3",
})
if py3 ~= nil then
  vim.g.python3_host_prog = py3
else
  vim.g.loaded_python3_provider = 2
end

require("dko.opt")
require("dko.builtin-syntax")
require("dko.diagnostic-lsp")
require("dko.terminal")
require("dko.commands")
require("dko.mappings")
require("dko.behaviors")
require("dko.lazy")

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
