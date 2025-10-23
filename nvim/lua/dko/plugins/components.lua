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
          -- only show indent guides of the scope
          only_scope = true,
        },
      },
      input = { enabled = input == "snacks" },
      picker = { ui_select = select == "snacks" },
      styles = {
        input = {
          border = dkosettings.get("pumborder"),
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

  -- https://github.com/nvim-mini/mini.icons
  {
    "nvim-mini/mini.icons",
    lazy = true,
    cond = has_ui,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    opts = {
      file = {
        -- bad glyph for maple mono
        -- https://github.com/nvim-mini/mini.icons/blob/ec61af6e606fc89ee3b1d8f2f20166a3ca917a36/lua/mini/icons.lua#L932C36-L932C37
        [".prettierignore"] = { glyph = "", hl = "MiniIconsOrange" },
      },
    },
  },
}
