local smallcaps = require("dko.utils.string").smallcaps
local dkohl = require("dko.heirline.utils").hl

-- List format-on-save clients for the buffer
return {
  condition = function()
    -- nil means NEVER registered
    return vim.b.formatters ~= nil
  end,
  {
    condition = function()
      return #vim.b.formatters == 0
    end,
    provider = " 󱃖 ",
    hl = function()
      -- empty table means probably LspStop happened
      return dkohl("DiffDelete")
    end,
  },

  {
    condition = function()
      return #vim.b.formatters > 0
    end,
    hl = function()
      return dkohl()
    end,
    provider = function()
      return "󱃖 " .. smallcaps(table.concat(vim.b.formatters, ",")) .. " "
    end,
  },
}
