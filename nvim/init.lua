-- Fallback for vims with no env access like Veonim
-- used by plugin/*
---@diagnostic disable-next-line: missing-parameter
vim.g.mapleader = " "

require("dko.providers")
require("dko.opt")
require("dko.builtin-syntax")
require("dko.diagnostic-lsp")
require("dko.terminal")
require("dko.commands")
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
require("lazy").setup("dko.plugins", {
  checker = { enabled = true },
  dev = {
    fallback = true,
    patterns = { "davidosomething" },
  },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen", -- vim-matchup will re-load this anyway
        --"netrwPlugin", -- sometimes i use this
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true
