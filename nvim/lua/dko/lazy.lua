local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.fn.getftype(lazypath) ~= "dir" then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("dko.plugins", {
  change_detection = {
    enabled = false,
  },
  checker = {
    -- needed to get the output of require("lazy.status").updates()
    enabled = true,
    -- get a notification when new updates are found?
    notify = false,
  },
  dev = {
    fallback = true,
    patterns = { "davidosomething" },
  },
  rocks = { enabled = false, hererocks = false },
  ui = { border = require("dko.settings").get("border") },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen", -- vim-matchup will re-load this anyway
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
