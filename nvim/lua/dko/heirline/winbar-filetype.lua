local dkohl = require("dko.heirline.utils").hl
local dkots = require("dko.utils.treesitter")
local utils = require("heirline.utils")

-- =======================================================================
-- filetype icon and text
-- =======================================================================

local function hl()
  if dkots.is_highlight_enabled() then
    return {
      bg = utils.get_highlight("dkoStatusKey").bg
        or utils.get_highlight("StatusLine").bg,
      fg = utils.get_highlight("StatusLine").fg,
    }
  end
  return utils.get_highlight("DiffDelete")
end

return {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  utils.surround({ "█", "" }, function()
    --- red if no treesitter
    local active = hl().bg
    local inactive = utils.get_highlight("dkoStatusKey").bg
      or utils.get_highlight("StatusLineNC").bg
    return dkohl(active, inactive)
  end, {
    {
      condition = function(self)
        return self.icon ~= ""
      end,
      provider = function(self)
        return self.icon
      end,
      hl = function()
        local _, icons = pcall(require, "nvim-web-devicons")
        if icons then
          local _, color = icons.get_icon_color_by_filetype(vim.bo.filetype)
          if color then
            return dkohl({ fg = color, bg = hl().bg }, "dkoStatusKey")
          end
        end
        return ""
      end,
    },
    {
      condition = function(self)
        return self.filetype_text ~= ""
      end,
      provider = function(self)
        return (self.icon ~= "" and " " or "") .. self.filetype_text
      end,
      hl = function()
        return dkohl(hl(), "dkoStatusKey")
      end,
    },
  }),
}
