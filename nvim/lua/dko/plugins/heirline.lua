local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  {
    "rebelot/heirline.nvim",
    cond = has_ui,
    dependencies = "echasnovski/mini.icons",
    init = function()
      local ALWAYS = 2
      vim.o.showtabline = ALWAYS
      local GLOBAL = 3
      vim.o.laststatus = GLOBAL
    end,
    --- Needs to be a config function, the various dko.heirline modules loaded
    --- all call heirline functions so expect the rtp setup and plugin to have
    --- loaded already
    config = function()
      require("heirline").setup({
        statusline = require("dko.heirline.statusline-default"),
        tabline = require("dko.heirline.tabline"),
        winbar = require("dko.heirline.winbar"),
        opts = {
          -- if the callback returns true, the winbar will be disabled for that window
          -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
          disable_winbar_cb = function(args)
            return require("heirline.conditions").buffer_matches({
              buftype = vim.tbl_filter(function(bt)
                return not vim.tbl_contains(
                  { "help", "quickfix", "terminal" },
                  bt
                )
              end, require("dko.utils.buffer").SPECIAL_BUFTYPES),
            }, args.buf)
          end,
        },
      })
    end,
  },
}
