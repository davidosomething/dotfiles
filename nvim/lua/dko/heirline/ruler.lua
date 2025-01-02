local utils = require("heirline.utils")

return {
  condition = require("heirline.conditions").is_active,
  utils.surround({ "", "█" }, function()
    return utils.get_highlight("StatusLine").bg
  end, {
    provider = "%5.(%c%)",
    hl = "StatusLine",
  }),
}
