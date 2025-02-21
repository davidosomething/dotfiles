local dkoescesc = require("dko.behaviors.escesc")
local dkosettings = require("dko.settings")

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
      fidget.setup()
      dkoescesc.add(function()
        fidget.notification.clear()
      end, "Dismiss notifications on <Esc><Esc>")
    end,
  },
}
