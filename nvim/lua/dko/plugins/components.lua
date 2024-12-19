local dkosettings = require("dko.settings")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local select = dkosettings.get("select")
local input = dkosettings.get("input")

return {
  -- https://github.com/folke/snacks.nvim/blob/main/docs/input.md
  {
    "folke/snacks.nvim",
    opts = {
      -- =======================================================================
      -- Indent and chunk guides. Alternatives:
      -- - https://github.com/nvimdev/indentmini.nvim
      -- - https://github.com/shellRaining/hlchunk.nvim
      -- - https://github.com/lukas-reineke/indent-blankline.nvim
      indent = {
        -- yes there's an indent nested inside
        indent = {
          only_scope = true, -- only show indent guides of the scope
        },
      },
      -- =======================================================================
      -- vim.ui.input replacement
      input = { enabled = input == "snacks" },
    },
  },

  -- Replace vim.ui.input used for rename
  -- Replace vim.ui.select, used for code action and some other things,
  -- but I'm probably using one of the code action specific plugins with preview
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    cond = has_ui and input == "dressing" or select == "dressing",
    event = "VeryLazy",
    opts = {
      input = {
        mappings = {
          n = {
            ["q"] = "Close",
          },
        },
      },
    },
  },

  -- https://github.com/nvim-tree/nvim-web-devicons
  -- use mini.icons instead
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   lazy = true,
  --   cond = has_ui,
  --   config = true,
  -- },

  -- https://github.com/echasnovski/mini.icons
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
