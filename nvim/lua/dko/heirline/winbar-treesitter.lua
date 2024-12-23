local dkobuffer = require("dko.utils.buffer")
local dkots = require("dko.utils.treesitter")
local conditions = require("heirline.conditions")
local hl = require("dko.heirline.utils").hl

-- =======================================================================
-- treesitter highlight status
-- =======================================================================

return {
  condition = function()
    return vim.bo.filetype ~= ""
      and not conditions.buffer_matches({
        buftype = dkobuffer.SPECIAL_BUFTYPES,
        filetype = dkobuffer.SPECIAL_FILETYPES,
      })
  end,
  provider = "  ",
  hl = function()
    return hl(dkots.is_highlight_enabled() and "DiffAdd" or "DiffDelete")
  end,
}
