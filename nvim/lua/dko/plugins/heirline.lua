return {
  {
    "davidosomething/everandever.nvim",
    dev = true,
  },

  {
    "rebelot/heirline.nvim",
    dependencies = {
      "davidosomething/everandever.nvim",
    },
    event = "VeryLazy",
    config = function()
      local ALWAYS = 2
      vim.o.showtabline = ALWAYS

      local GLOBAL = 3
      vim.o.laststatus = GLOBAL

      require("heirline").setup({
        statusline = {
          fallthrough = false,
          require("dko.heirline.statusline-special"),
          require("dko.heirline.statusline-default"),
        },
        tabline = require("dko.heirline.tabline"),
        winbar = require("dko.heirline.winbar"),
      })
    end,
  },
}
