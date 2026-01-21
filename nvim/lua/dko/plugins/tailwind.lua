---@type LazySpec
return {

  -- https://github.com/MaximilianLloyd/tw-values.nvim
  -- {
  --   "MaximilianLloyd/tw-values.nvim",
  --   cmd = "TWValues",
  --   config = function()
  --     require("tw-values").setup()
  --     require("dko.mappings").bind_twvalues()
  --   end,
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   keys = require("dko.mappings").twvalues,
  -- },

  -- https://github.com/ruicsh/tailwind-hover.nvim
  {
    "ruicsh/tailwind-hover.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = require("dko.mappings").tailwind_hover,
  },
}
