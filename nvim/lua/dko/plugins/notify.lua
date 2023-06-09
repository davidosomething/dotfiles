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
        max_width = 100,
        minimum_width = 50,
        timeout = 2500,
        stages = "static",
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

      ---@alias MessageType
      ---| 1 # Error
      ---| 2 # Warning
      ---| 3 # Info
      ---| 4 # Log

      ---@alias LogLevel
      ---| 0 # TRACE
      ---| 1 # DEBUG
      ---| 2 # INFO
      ---| 3 # WARN
      ---| 4 # ERROR
      ---| 5 # OFF

      ---Convert an LSP MessageType to a vim.notify log level
      ---@param mt MessageType https://github.com/neovim/neovim/blob/7ef5e363d360f86c5d8d403e90ed256f4de798ec/runtime/lua/vim/lsp/protocol.lua
      ---@return LogLevel level https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_editor.lua#L44-L53
      local function lsp_messagetype_to_vim_log_level(mt)
        local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[mt]
        return vim.log.levels[lvl]
      end

      ---Show LSP messages via vim.notify (but only when using nvim-notify)
      ---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, _)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local client_name = client and client.name or ctx.client_id
        local title = ("LSP > %s"):format(client_name)
        if not client then
          vim.notify(result.message, vim.log.levels.ERROR, { title = title })
        else
          local level = lsp_messagetype_to_vim_log_level(result.type)
          vim.notify(result.message, level, { title = title })
        end
        return result
      end
    end,
  },
}
