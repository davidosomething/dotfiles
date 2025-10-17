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

---@param args { buf: number } table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
---@return boolean -- true to hide winbar
local function disable_winbar_cb(args)
  return require("heirline.conditions").buffer_matches({
    buftype = WINBAR_DISABLED_BUFTYPES,
    -- diff and snacks_picker_preview are used by the picker for
    -- tiny-code-action
    filetype = { "diff", "fzf", "snacks_picker_preview" },
  }, args.buf)
end

return {
  {
    "rebelot/heirline.nvim",
    cond = has_ui,
    dependencies = "nvim-mini/mini.icons",
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
        opts = { disable_winbar_cb = disable_winbar_cb },
      })
    end,
  },
}
