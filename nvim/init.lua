-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.mapleader = " "

require("dko.external")
require("dko.providers")
require("dko.opt")
require("dko.builtin-plugins")
require("dko.builtin-syntax")
require("dko.diagnostic-lsp")
require("dko.terminal")
require("dko.mappings")
require("dko.behaviors")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(require("dko.plugins"), {
  checker = { enabled = true },
  ui = { border = "rounded" },
})

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
