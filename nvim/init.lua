-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.vdotdir = vim.fn.expand(vim.fn.empty('$VDOTDIR') == 1 and '$XDG_CONFIG_DIR/nvim' or '$VDOTDIR')
vim.g.dko_rtp_original = vim.o.runtimepath
vim.g.mapleader = ' '

-- Plugin settings
vim.g.dko_autoinstall_vim_plug = vim.fn.executable('git')
vim.g.dko_use_completion = vim.fn.executable('node')
vim.g.dko_use_fzf = vim.fn.exists('&autochdir')
vim.g.truecolor = vim.fn.getenv('TERM_PROGRAM') ~= 'Apple_Terminal' and (vim.fn.getenv('COLORTERM') == 'truecolor' or vim.fn.getenv('DOTFILES_OS') == 'Darwin')

require('dko.providers')
require('dko.opt')
require('dko.builtin-plugins')
require('dko.builtin-syntax')
require('dko.behaviors')
require('dko.mappings')
require('dko.terminal')

vim.cmd('source ' .. vim.g.vdotdir .. '/legacy-plug.vim')

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
