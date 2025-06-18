local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local dev = vim.env.NVIM_DEV ~= nil

return {
  {
    "davidosomething/format-ts-errors.nvim",
    cond = has_ui,
    dev = dev,
    config = function()
      local f = require("format-ts-errors")
      f.setup({
        add_markdown = false,
        start_indent_level = 0,
      })
      -- register a new message formatter for tsserver
      require("dko.diagnostic").message_formatters["tsserver"] = function(
        diagnostic
      )
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

  -- https://github.com/angelinuxx/npm-lens.nvim
  -- Parses JSON output of npm outdated --json
  -- Has BufReadPost autocmd
  {
    "angelinuxx/npm-lens.nvim",
    cond = has_ui,
    cmd = "NpmLensToggle",
    opts = {
      enabled = false, -- If false, info in `package.json` won't display until `:NpmLensToggle` is used
    },
  },

  -- https://github.com/vuki656/package-info.nvim
  -- Parses string output of npm outdated
  -- {
  --   "vuki656/package-info.nvim",
  --   cond = has_ui,
  --   dependencies = "MunifTanjim/nui.nvim",
  --   event = "BufReadPost package.json",
  --   config = function()
  --     require("package-info").setup({
  --       hide_up_to_date = true,
  --     })
  --
  --     local c = require("package-info/utils/constants")
  --     vim.api.nvim_create_autocmd("User", {
  --       group = c.AUTOGROUP,
  --       pattern = c.LOAD_EVENT,
  --       callback = function()
  --         -- execute a groupless autocmd so heirline can update
  --         vim.cmd.doautocmd("User", "DkoPackageInfoStatusUpdate")
  --       end,
  --     })
  --   end,
  -- },
}
