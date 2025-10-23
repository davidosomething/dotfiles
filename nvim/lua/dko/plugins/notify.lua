local dkosettings = require("dko.settings")
local winborder = dkosettings.get("winborder")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local notifier = dkosettings.get("notify")

return {
  -- Some alternatives I have used before
  -- https://github.com/ObserverOfTime/notifications.nvim
  -- https://github.com/rcarriga/nvim-notify

  -- Used for errors and more important notifications
  -- escesc is bound in ../notify.lua
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        enabled = notifier == "snacks",
        style = "compact",
        width = { min = 56, max = 0.4 },
        margin = { top = 1, right = 1, bottom = 2 },
      },
      styles = {
        notification = { border = winborder },
        notification_history = { border = winborder },
      },
    },
  },

  -- Used for LSP notifications
  -- https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    cond = has_ui,
    config = function()
      local fidget = require("fidget")
      fidget.setup({})
      require("dko.behaviors.escesc").add(function()
        fidget.notification.clear()
      end, "Dismiss notifications on <Esc><Esc>")
    end,
  },
}
