-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.vdotdir = vim.fs.dirname(vim.env.MYVIMRC)
vim.g.mapleader = ' '

require('dko.external')
require('dko.providers')
require('dko.opt')
require('dko.builtin-plugins')
require('dko.builtin-syntax')
require('dko.diagnostic-lsp')
require('dko.terminal')
require('dko.mappings')

require('dko.behaviors')

require('dko.lazy.install')
local plugins = require('dko.lazy.plugins')
local opts = {
  checker = { enabled = true },
  ui = { border = 'rounded' },
}
require('lazy').setup(plugins, opts)

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
