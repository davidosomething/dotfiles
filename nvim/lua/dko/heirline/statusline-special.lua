--
-- this file not used any more, just here for reference
--

return {
  condition = function()
    return require("heirline.conditions").buffer_matches({
      buftype = require("dko.utils.buffer").SPECIAL_BUFTYPES,
      filetype = require("dko.utils.buffer").SPECIAL_FILETYPES,
    })
  end,
  require("dko.heirline.searchterm"),
  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with inactive color
  {
    provider = "%=",
    hl = "StatusLineNC",
  },

  -- ruler
  {
    condition = require("heirline.conditions").is_active,
    provider = "%5.(%c%) ",
    hl = "StatusLine",
  },
}
