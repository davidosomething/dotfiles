---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      --  {
      --    no longer needed https://github.com/neovim/neovim/pull/20198
      --    "antoinemadec/FixCursorHold.nvim",
      --  },
      "nvim-treesitter/nvim-treesitter",
      -- == adapters ===========================================================
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest"),
        },
        floating = {
          border = "single",
        },
        output = {
          open_on_run = true,
        },
      })
    end,
  },
}
