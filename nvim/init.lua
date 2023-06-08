-- polyfill nvim 0.9 change
vim.print = vim.print or vim.pretty_print

-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.mapleader = " "

-- Must be 0 and not false
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0 -- disable python 2

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

require("dko.filetypes")
require("dko.opt")
require("dko.builtin-syntax")
require("dko.diagnostic")
require("dko.lsp")
require("dko.terminal")
require("dko.commands")
require("dko.mappings")
require("dko.behaviors")
require("dko.lazy")

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
