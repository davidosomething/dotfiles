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
    opts = {
      --- merge spec
      input = { enabled = input == "snacks" },
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

  -- use mini.icons instead
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   lazy = true,
  --   cond = has_ui,
  --   config = true,
  -- },
  {
    "echasnovski/mini.icons",
    lazy = true,
    cond = has_ui,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = true,
  },
}
