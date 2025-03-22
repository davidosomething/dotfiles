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
      -- Don't use watchman until this is properly resolved
      -- https://github.com/neoclide/coc.nvim/issues/4490
      -- if vim.fn.executable("watchman") == 0 then
      --   require("dko.doctor").warn({
      --     category = "coc",
      --     message = "[coc] `watchman` not found",
      --   })
      -- end

      vim.g.coc_start_at_startup = true
      vim.g.coc_global_extensions = {
        "coc-eslint", -- since it gives code actions unified with tsserver
        "coc-json",
        "coc-tsserver",
      }
    end,
  },
}
