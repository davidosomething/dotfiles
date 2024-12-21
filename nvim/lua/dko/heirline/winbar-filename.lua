local utils = require("heirline.utils")
local hl = require("dko.heirline.utils").hl

local DIRTY = { fg = utils.get_highlight("Todo").fg }

return {
  condition = function()
    return vim.bo.buftype == "" or vim.bo.buftype == "help"
  end,
  { provider = " " },
  {
    provider = function()
      return vim.bo.modified and "● " or ""
    end,
    -- Always has color, even on inactive pane
    hl = DIRTY,
  },
  {
    provider = function(self)
      if self.filepath == "" then
        return "ᴜɴɴᴀᴍᴇᴅ"
      end
      return vim.fn.fnamemodify(self.filepath, ":t")
    end,
    hl = function()
      return hl(vim.bo.modified and DIRTY or "StatusLine")
    end,
  },
  { provider = " " },
}
