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
      require("heirline").setup({
        statusline = {
          fallthrough = false,
          require("dko.heirline.statusline-special"),
          require("dko.heirline.statusline-default"),
        },
        tabline = {
          require("dko.heirline.searchterm"),
          { provider = "%=", hl = "StatusLine" },
          require("dko.heirline.cwd"),
          require("dko.heirline.git"),
          require("dko.heirline.lazy"),
          require("dko.heirline.remote"),
        },
      })
      local ALWAYS = 2
      vim.o.showtabline = ALWAYS
    end,
  },

}
