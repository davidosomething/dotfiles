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
require("dko.tools.mdx")
require("dko.tools.python")
require("dko.tools.qml")
require("dko.tools.rust")
require("dko.tools.sh")
require("dko.tools.tiltfile")
require("dko.tools.toml")
require("dko.tools.yaml")

-- plugins might rely or trigger things from my settings above
require("dko.lazy")

-- for things not handled by plugins, or that plugins did wrong
require("dko.builtin-syntax")
require("dko.filetypes")
require("dko.treesitter")

require("dko.lsp") -- override some lsp handlers
require("dko.notify") -- override some vim.notify with plugins

require("dko.terminal")

-- disable osc52 paste
-- follow https://github.com/davidosomething/dotfiles/issues/580
-- follow https://github.com/wezterm/wezterm/issues/2050
-- copied some from https://github.com/oldnaari/kickstart.nvim/commit/f3c3ee9a9e56eff000a9eb55b22acacbb73fbe6e
-- for when wl-paste is available, bue leave noops since TERM_PROGRAM is not
-- accepted in all ssh envs
local wezterm_on_linux = vim.env.TERM_PROGRAM == "WezTerm"
  and vim.uv.os_uname().sysname == "Linux"
  and vim.fn.executable("wl-paste") == 1
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  -- disable osc52 paste
  paste = wezterm_on_linux and {
    ["+"] = { "wl-paste", "--no-newline", "--type", "text/plain" },
    ["*"] = {
      "wl-paste",
      "--no-newline",
      "--primary",
      "--type",
      "text/plain",
    },
  } or {
    ["+"] = function() end,
    ["*"] = function() end,
  },
}

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
