-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.mapleader = " "

-- Must be 0 and not false
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0 -- disable python 2
vim.g.loaded_python3_provider = 0 -- disable python 3 also, who's still using these?

require("dko.opt")
require("dko.commands")
require("dko.behaviors")
require("dko.diagnostic")
require("dko.mappings")
require("dko.mappings.finder").bind_finder()

require("dko.tools.csharp")
require("dko.tools.dart")
require("dko.tools.docker")
require("dko.tools.generic")
require("dko.tools.go")
require("dko.tools.html")
require("dko.tools.javascript-typescript")
require("dko.tools.json")
require("dko.tools.lua")
require("dko.tools.markdown")
require("dko.tools.python")
require("dko.tools.qml")
require("dko.tools.rust")
require("dko.tools.sh")
require("dko.tools.text")
require("dko.tools.tiltfile")
require("dko.tools.yaml")

-- plugins might rely or trigger things from my settings above
require("dko.lazy")

-- for things not handled by plugins, or that plugins did wrong
require("dko.builtin-syntax")
require("dko.filetypes")

require("dko.lsp") -- override some lsp handlers
require("dko.notify") -- override some vim.notify with plugins

require("dko.terminal")

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
