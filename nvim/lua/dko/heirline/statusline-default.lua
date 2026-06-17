return {
  require("dko.heirline.mode"),
  require("dko.heirline.filetype"),
  require("dko.heirline.formatters"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with inactive color
  {
    provider = "%=",
    hl = "StatusLineNC",
  },

  require("dko.heirline.searchterm"),

  {
    condition = function(self)
      return vim.ui.progress_status
    end,
    provider = function()
      local _, res = pcall(vim.ui.progress_status)
      return res or ""
    end,
  },

  require("dko.heirline.ruler"),
}
