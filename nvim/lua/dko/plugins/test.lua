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
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-vitest"),
        },
        ---@diagnostic disable-next-line: missing-fields
        floating = {
          border = "single",
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
      })
    end,
  },
}
