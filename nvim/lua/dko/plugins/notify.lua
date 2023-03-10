local SIGNS = require("dko.diagnostic").SIGNS

return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require("notify")
      notify.setup({
        max_height = 8,
        max_width = 50,
        minimum_width = 50,
        timeout = 2500,
        stages = vim.go.termguicolors and "fade_in_slide_out" or "slide",
        icons = {
          DEBUG = "",
          ERROR = SIGNS.Error,
          INFO = SIGNS.Info,
          TRACE = "✎",
          WARN = SIGNS.Warn,
        },
      })

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
        if not opts.title then
          if require("dko.utils.string").starts_with(msg, "[LSP]") then
            local client, found_client = msg:gsub("^%[LSP%]%[(.-)%] .*", "%1")
            if found_client > 0 then
              opts.title = ("LSP > %s"):format(client)
            else
              opts.title = "LSP"
            end
            msg = msg:gsub("^%[.*%] (.*)", "%1")
          elseif msg == "No code actions available" then
            -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#LL629C39-L629C39
            opts.title = "LSP"
          end
        end
        notify(msg, level, opts)
      end
      vim.notify = override
      require('dko.lsp').bind_notify()

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
      require("dko.mappings").bind_notify()
    end,
  },
}
