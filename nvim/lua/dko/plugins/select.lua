local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

--- @type 'dressing'|'snacks'
local select = "snacks"

return {
  {
    "folke/snacks.nvim",
    cond = has_ui,
    enabled = select == "snacks",
    opts = {
      input = {},
    },
  },

  -- Replace vim.ui.select and vim.ui.input, which are used by things like
  -- vim.lsp.buf.code_action and rename
  -- Alternatively could use https://github.com/nvim-telescope/telescope-ui-select.nvim
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    cond = has_ui,
    enabled = select == "dressing",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({})
    end,
  },
}
