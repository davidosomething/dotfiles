local dkodiagnostic = require("dko.diagnostic")
local dkosettings = require("dko.settings")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local dev = vim.env.NVIM_DEV ~= nil

return {
  {
    "davidosomething/format-ts-errors.nvim",
    cond = has_ui and dkosettings.get("use_coc"),
    dev = dev,
    config = function()
      local f = require("format-ts-errors")
      f.setup({
        add_markdown = false,
        start_indent_level = 0,
      })
      -- register a new message formatter for tsserver
      dkodiagnostic.message_formatters["tsserver"] = function(diagnostic)
        local formatter = f[diagnostic.code]
        if not formatter then
          vim.schedule(function()
            vim.print(
              ("format-ts-errors no formatter for [%d] %s"):format(
                diagnostic.code,
                diagnostic.message
              )
            )
          end)
          return diagnostic.message
        end
        local formatted = formatter(diagnostic.message)
        return table.concat({
          formatted,
          "==== ꜰᴏʀᴍᴀᴛ-ᴛs-ᴇʀʀᴏʀs.ɴᴠɪᴍ ====",
        }, "\n")
      end
    end,
  },

  -- Using this for tsserver specifically, faster results than nvim-lsp
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = has_ui and dkosettings.get("use_coc"),
    init = function()
      --- Look for watchman and report if not found
      local on_exit = function(obj)
        if obj.code > 0 then
          require("dko.doctor").warn({
            category = "coc",
            message = "`watchman` not found (for coc.nvim)",
          })
        end
      end
      vim.system({ "command", "-v", "watchman" }, { text = true }, on_exit)

      vim.g.coc_start_at_startup = true
      vim.g.coc_global_extensions = {
        "coc-eslint", -- since it gives code actions unified with tsserver
        "coc-json",
        "coc-tsserver",
      }
    end,
  },
}
