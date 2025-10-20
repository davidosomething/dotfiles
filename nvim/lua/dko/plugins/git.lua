local dkosettings = require("dko.settings")
local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- show diff when editing a COMMIT_EDITMSG
  {
    "rhysd/committia.vim",
    lazy = false, -- just in case
    init = function()
      vim.g.committia_open_only_vim_starting = 0
      vim.g.committia_use_singlecolumn = "always"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cond = has_ui,
    opts = {
      on_attach = require("dko.mappings").bind_gitsigns,
      preview_config = {
        border = dkosettings.get("pumborder"),
      },
    },
  },

  { "sindrets/diffview.nvim" },

  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        blame_line = {
          border = dkosettings.get("winborder"),
        },
      },
    },
  },
}
