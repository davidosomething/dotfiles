local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

--- Also consider https://github.com/nvim-telescope/telescope-ui-select.nvim ?
--- @type ''|'dressing'|'snacks'
local select = ""

--- @type ''|'dressing'|'snacks'
local input = "snacks"

return {
  -- https://github.com/folke/snacks.nvim/blob/main/docs/input.md
  {
    "folke/snacks.nvim",
    cond = has_ui,
    enabled = input == "snacks",
    opts = {
      input = {},
    },
  },

  -- Replace vim.ui.input used for rename
  -- Replace vim.ui.select, used for code action and some other things,
  -- but I'm probably using one of the code action specific plugins with preview
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    cond = has_ui,
    enabled = input == "dressing" or select == "dressing",
    event = "VeryLazy",
    opts = {},
  },
}
