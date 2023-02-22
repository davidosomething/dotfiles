-- =========================================================================
-- fixes / polyfills for neovim behavior
-- =========================================================================

return {
  -- Fix CursorHold
  -- https://github.com/neovim/neovim/issues/12587
  {
    "antoinemadec/FixCursorHold.nvim",
    enabled = vim.fn.has("nvim-0.8") == 0,
  },

  -- Disable cursorline when moving, for various perf reasons
  {
    "yamatsum/nvim-cursorline", -- replaces delphinus/auto-cursorline.nvim",
    config = function()
      require("nvim-cursorline").setup({
        cursorline = {
          enable = true,
          timeout = 300,
          number = false,
        },
        cursorword = {
          enable = false, -- https://github.com/yamatsum/nvim-cursorline/issues/27
          min_length = 3,
          hl = { underline = true },
        },
      })
    end,
  },

  -- apply editorconfig settings to buffer
  -- @TODO follow https://github.com/neovim/neovim/issues/21648
  {
    "gpanders/editorconfig.nvim",
    enabled = vim.fn.has("nvim-0.9") == 0,
  },

  -- prevent new windows from shifting cursor position
  {
    "luukvbaal/stabilize.nvim",
    enabled = vim.fn.exists("+splitkeep") == 0,
    config = function()
      require("stabilize").setup()
    end,
  },
}
