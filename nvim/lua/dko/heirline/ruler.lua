return {
  condition = require("heirline.conditions").is_active,
  require("heirline.utils").surround({ "", "█" }, function()
    return require("heirline.utils").get_highlight("StatusLine").bg
  end, {
    provider = "%5.(%c%)",
    hl = "StatusLine",
  }),
}
