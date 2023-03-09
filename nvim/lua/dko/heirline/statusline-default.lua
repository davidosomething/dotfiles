return {
  require("dko.heirline.mode"),
  require("dko.heirline.buftype"),
  require("dko.heirline.filetype"),
  require("dko.heirline.filename"),
  require("dko.heirline.fileflags"),

  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },

  require("dko.heirline.align"),
  require("dko.heirline.lsp"),
  require("dko.heirline.diagnostics"),
  {
    condition = require("heirline.conditions").is_active,
    provider = "%5.(%c%) ",
    hl = "dkoStatusItem",
  },
}
