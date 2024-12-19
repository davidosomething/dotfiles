local dkosettings = require("dko.settings")

local dev = vim.env.NVIM_DEV ~= nil

return {
  {
    "davidosomething/vim-colors-meh",
    cond = #vim.api.nvim_list_uis() > 0,
    dependencies = {
      -- { "rakr/vim-two-firewatch", lazy = true },
      -- {
      --   "mcchrish/zenbones.nvim",
      --   lazy = true,
      --   dependencies = { "rktjmp/lush.nvim" },
      -- },
      "ntk148v/komau.vim",
    },
    dev = dev,
    lazy = false,
    priority = 1000,
    init = function()
      dkosettings.set("colors.dark", "meh")
      dkosettings.set("colors.light", "komau")
    end,
    config = function()
      vim.cmd.colorscheme("meh")
      if vim.env.TERM_PROGRAM == "WezTerm" then
        require("dko.colors").wezterm_sync()
      end
    end,
  },
}
