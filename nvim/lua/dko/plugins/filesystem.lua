local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- help nvim resolve correct filename and filetype when using sudoedit
  -- https://github.com/HE7086/sudoedit.nvim
  {
    "HE7086/sudoedit.nvim",
    cond = has_ui,
    enabled = function()
      return vim.fn.has("linux") == 1
    end,
  },

  -- because https://github.com/neovim/neovim/issues/1496
  -- once https://github.com/neovim/neovim/pull/10842 is merged, there will
  -- probably be a better implementation for this
  {
    "lambdalisue/vim-suda",
    cond = has_ui,
    cmd = "SudaWrite",
  },
}
