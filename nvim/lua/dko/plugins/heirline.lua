local dkobuffer = require("dko.utils.buffer")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---Special buftypes hash where the winbar should be enabled
local WINBAR_ENABLED_BUFTYPES = {
  help = true,
  quickfix = true,
  ---fzf-lua uses a terminal buffer, so we need to do more filtering...
  terminal = true,
}

local WINBAR_DISABLED_BUFTYPES = {}
for _, buftype in pairs(dkobuffer.SPECIAL_BUFTYPES) do
  if not WINBAR_ENABLED_BUFTYPES[buftype] then
    table.insert(WINBAR_DISABLED_BUFTYPES, buftype)
  end
end

---@param args { buf: number }
local function disable_winbar_cb(args)
  local hc = require("heirline.conditions")
  return hc.buffer_matches({
    buftype = WINBAR_DISABLED_BUFTYPES,
    filetype = { "fzf" },
  }, args.buf)
end

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
          disable_winbar_cb = disable_winbar_cb,
        },
      })
    end,
  },
}
