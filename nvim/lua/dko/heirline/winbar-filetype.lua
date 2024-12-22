local hl = require("dko.heirline.utils").hl
local utils = require("heirline.utils")

-- =======================================================================
-- filetype icon and text
-- =======================================================================

return {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  utils.surround({ "", "" }, function()
    return utils.get_highlight("dkoStatusKey").bg
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
            return hl({ fg = color }, "dkoStatusKey")
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
      hl = "dkoStatusKey",
    },
  }),
}
