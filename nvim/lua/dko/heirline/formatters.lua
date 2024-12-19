local conditions = require("heirline.conditions")

-- List format-on-save clients for the buffer
return {
  condition = function()
    return vim.b.formatters ~= nil and #vim.b.formatters > 0
  end,
  {
    provider = " 󰳻 ",
    hl = function()
      return conditions.is_active() and "dkoStatusKey" or "StatusLineNC"
    end,
  },
  {
    provider = function()
      return (" %s "):format(table.concat(vim.b.formatters, ", "))
    end,
    hl = function()
      return conditions.is_active() and "StatusLine" or "StatusLineNC"
    end,
  },
}
