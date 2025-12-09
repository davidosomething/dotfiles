return {
  require("dko.heirline.mode"),
  require("dko.heirline.lightbulb"),
  require("dko.heirline.searchterm"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with inactive color
  {
    provider = "%=",
    hl = "StatusLineNC",
  },

  require("dko.heirline.ruler"),
}
