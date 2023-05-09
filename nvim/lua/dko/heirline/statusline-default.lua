return {
  require("dko.heirline.mode"),
  require("dko.heirline.searchterm"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with inactive color
  {
    provider = "%=",
    hl = "StatusLineNC"
  },

  -- ruler
  {
    condition = require("heirline.conditions").is_active,
    provider = "%5.(%c%) ",
    hl = "StatusLine",
  },
}
