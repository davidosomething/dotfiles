local utils = require("heirline.utils")

return {
  utils.surround({ "█", "" }, function()
    return utils.get_highlight("StatusLine").bg
  end, {
    require("dko.heirline.mode"),
  }),

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
    utils.surround({ "", "█" }, function()
      return utils.get_highlight("StatusLine").bg
    end, {
      provider = "%5.(%c%)",
      hl = "StatusLine",
    }),
  },
}
