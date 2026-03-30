return {
  require("dko.heirline.mode"),
  require("dko.heirline.searchterm"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with inactive color
  {
    provider = "%=",
    hl = "StatusLineNC",
  },

  -- spacer with inactive color
  {
    provider = function()
      return vim.ui.progress_status()
    end,
  },

  require("dko.heirline.formatters"),
  require("dko.heirline.ruler"),
}
