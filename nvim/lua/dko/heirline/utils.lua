local M = {}

M.hidden_filetypes = require("dko.utils.table").concat({
  "markdown",
}, require("dko.utils.jsts").fts)

M.hl = function(active, inactive)
  active = active or "StatusLine"
  inactive = inactive or "StatusLineNC"
  local conditions = require("heirline.conditions")
  return conditions.is_active() and active or inactive
end

return M
