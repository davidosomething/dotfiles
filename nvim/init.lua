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
  "$XDG_DATA_HOME/rtx/shims/python",
  "$ASDF_DIR/shims/python",
  "/usr/bin/python3",
})
if py3 ~= nil then
  vim.g.python3_host_prog = py3
else
  vim.g.loaded_python3_provider = 2
end

require("dko.opt")

require("dko.toolchains.lua")
require("dko.toolchains.python")
require("dko.toolchains.sh")
require("dko.toolchains.vim")
require("dko.toolchains.yaml")

require("dko.commands")
require("dko.behaviors")
require("dko.diagnostic")
require("dko.mappings")

-- plugins might rely or trigger things from my settings above
require("dko.lazy")

-- for things not handled by plugins, or that plugins did wrong
require("dko.builtin-syntax")
require("dko.filetypes")
require("dko.lsp.floats")
require("dko.terminal")

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
