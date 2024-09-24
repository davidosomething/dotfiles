-- =========================================================================
-- fixes / polyfills for neovim behavior
-- =========================================================================

return {
  -- Disable cursorline when moving, for various perf reasons
  {
    "yamatsum/nvim-cursorline", -- replaces delphinus/auto-cursorline.nvim
    cond = #vim.api.nvim_list_uis() > 0,
    config = function()
      require("nvim-cursorline").setup({
        cursorline = {
          enable = true,
          timeout = 300,
          number = false,
        },
        cursorword = {
          -- known issue https://github.com/yamatsum/nvim-cursorline/issues/27
          -- but i don't use netrw, so maybe non-issue
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      })
    end,
  },
}
