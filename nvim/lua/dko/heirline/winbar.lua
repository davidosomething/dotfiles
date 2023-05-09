return {
  require("dko.heirline.filetype"),
  require("dko.heirline.filename"),
  require("dko.heirline.fileflags"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  -- spacer with active bg color
  {
    provider = "%=",
    hl = function()
      return require("heirline.conditions").is_active() and "StatusLine"
        or "StatusLineNC"
    end,
  },

  require("dko.heirline.lsp"),
  require("dko.heirline.diagnostics"),
}
