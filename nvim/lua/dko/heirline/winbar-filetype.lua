local dkohl = require("dko.heirline.utils").hl
local dkots = require("dko.utils.treesitter")
local utils = require("heirline.utils")

-- =======================================================================
-- filetype icon and text
-- =======================================================================

return {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  init = function(self)
    self.bg = dkots.is_highlight_enabled()
        and utils.get_highlight("dkoStatusKey").bg
      or utils.get_highlight("DiffDelete").bg
    self.fg = dkots.is_highlight_enabled()
        and utils.get_highlight("StatusLine").fg
      or utils.get_highlight("DiffDelete").fg
    self.treesitter_active = {
      fg = self.fg,
      bg = self.bg,
    }
  end,

  utils.surround({ "", "" }, function()
    local bg = dkots.is_highlight_enabled()
        and utils.get_highlight("dkoStatusKey").bg
      or utils.get_highlight("DiffDelete").bg
    --- red if no treesitter
    return dkohl(bg, utils.get_highlight("dkoStatusKey").bg)
  end, {
    {
      condition = function(self)
        return self.icon ~= ""
      end,
      provider = function(self)
        return self.icon
      end,
      hl = function(self)
        local _, icons = pcall(require, "nvim-web-devicons")
        if icons then
          local _, color = icons.get_icon_color_by_filetype(vim.bo.filetype)
          if color then
            return dkohl({ fg = color, bg = self.bg }, "dkoStatusKey")
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
      hl = function(self)
        return dkohl(self.treesitter_active, "dkoStatusKey")
      end,
    },
  }),
}
