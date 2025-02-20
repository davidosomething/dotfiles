local dkosettings = require("dko.settings")
local dkoicons = require("dko.icons")
local dkoescesc = require("dko.behaviors.escesc")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local notifier = dkosettings.get("notify")

return {
  -- Let terminal handle notification via OSC 777, persists until closed
  -- https://github.com/ObserverOfTime/notifications.nvim
  -- {
  --   "ObserverOfTime/notifications.nvim",
  --   cond = has_ui,
  --   config = function()
  --     vim.g.notifications_use_osc = "777"
  --     require("notifications").setup({
  --       -- don't take over vim.notify, use with require().notify() instead
  --       override_notify = false,
  --       -- raw with require()._history
  --       hist_command = "TNotifications",
  --       -- or set `icons = false` to disable all icons
  --       icons = {
  --         TRACE = dkoicons.Trace,
  --         DEBUG = dkoicons.Debug,
  --         INFO = dkoicons.Info,
  --         WARN = dkoicons.Warn,
  --         ERROR = dkoicons.Error,
  --         OFF = dkoicons.Off,
  --       },
  --       hl_groups = {
  --         TRACE = "DiagnosticFloatingHint",
  --         DEBUG = "DiagnosticFloatingHint",
  --         INFO = "DiagnosticFloatingInfo",
  --         WARN = "DiagnosticFloatingWarn",
  --         ERROR = "DiagnosticFloatingError",
  --         OFF = "DiagnosticFloatingOk",
  --       },
  --     })
  --   end,
  -- },

  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = notifier == "snacks" },
    },
  },

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

  -- vim ui notification
  -- https://github.com/rcarriga/nvim-notify
  {
    "rcarriga/nvim-notify",
    cond = has_ui and notifier == "notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require("notify")
      notify.setup({
        max_height = 8,
        max_width = 100,
        minimum_width = 50,
        timeout = 2500,
        stages = "static",
        icons = {
          DEBUG = dkoicons.Debug,
          ERROR = dkoicons.Error,
          INFO = dkoicons.Info,
          TRACE = dkoicons.Trace,
          WARN = dkoicons.Warn,
        },
      })
      dkoescesc.add(function()
        notify.dismiss({ silent = true, pending = true })
      end, "Dismiss notifications on <Esc><Esc>")
    end,
  },
}
