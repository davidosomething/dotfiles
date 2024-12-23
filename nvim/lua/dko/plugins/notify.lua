local icons = require("dko.icons")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

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
  --         TRACE = icons.Trace,
  --         DEBUG = icons.Debug,
  --         INFO = icons.Info,
  --         WARN = icons.Warn,
  --         ERROR = icons.Error,
  --         OFF = icons.Off,
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

  -- https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    cond = has_ui,
    config = function()
      local fidget = require("fidget")
      fidget.setup()

      vim.api.nvim_create_autocmd("User", {
        pattern = "EscEscEnd",
        desc = "Dismiss notifications on <Esc><Esc>",
        callback = function()
          fidget.notification.clear()
        end,
        group = vim.api.nvim_create_augroup("dkofidget", {}),
      })
    end,
  },

  -- vim ui notification
  -- https://github.com/rcarriga/nvim-notify
  {
    "rcarriga/nvim-notify",
    cond = has_ui,
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
          DEBUG = icons.Debug,
          ERROR = icons.Error,
          INFO = icons.Info,
          TRACE = icons.Trace,
          WARN = icons.Warn,
        },
      })
      require("dko.behaviors.escesc").add(function()
        notify.dismiss({ silent = true, pending = true })
      end, "Dismiss notifications on <Esc><Esc>")
    end,
  },
}
