local icons = require("dko.icons")
local dkostring = require("dko.utils.string")

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
    dependencies = { "rcarriga/nvim-notify" },
    config = function()
      local fidget = require("fidget")
      local notify = require("notify")
      fidget.setup()

      -- =====================================================================
      -- Override vim.notify builtin
      -- =====================================================================

      ---@param msg string
      ---@param level? number vim.log.levels.*
      ---@param opts? table
      local override = function(msg, level, opts)
        if not opts then
          opts = {}
        end

        -- known special titles
        -- mason ones should not go to fidget because mason window will cover it
        -- - "mason.nvim"
        -- - "mason-lspconfig.nvim"
        -- - "nvim-treesitter"

        if opts.title == "nvim-treesitter" then
          return fidget.notify(msg, level, opts)
        end

        if not opts.title then
          if dkostring.starts_with(msg, "[LSP]") then
            opts.render = "wrapped-compact"
            local client, found_client = msg:gsub("^%[LSP%]%[(.-)%] .*", "%1")
            if found_client > 0 then
              opts.title = ("[LSP] %s"):format(client)
            else
              opts.title = "[LSP]"
            end
            msg = msg:gsub("^%[.*%] (.*)", "%1")
          elseif msg == "No code actions available" then
            -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#LL629C39-L629C39
            opts.title = "[LSP]"
          end
        end

        if opts.title and dkostring.starts_with(opts.title, "[LSP]") then
          opts.render = "wrapped-compact"
        end

        return notify(msg, level, opts)
      end
      vim.notify = override

      -- =====================================================================
      -- Clear notifications on <Esc><Esc>
      -- =====================================================================

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

      -- =====================================================================
      -- Clear notifications on <Esc><Esc>
      -- =====================================================================

      vim.api.nvim_create_autocmd("User", {
        pattern = "EscEscEnd",
        desc = "Dismiss notifications on <Esc><Esc>",
        callback = function()
          notify.dismiss({ silent = true, pending = true })
        end,
        group = vim.api.nvim_create_augroup("dkonvimnotify", {}),
      })
    end,
  },
}
