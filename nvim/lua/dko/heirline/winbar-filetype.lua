local utils = require("heirline.utils")

local function hl()
  if require("dko.utils.treesitter").is_highlight_enabled() then
    return {
      bg = utils.get_highlight("StatusLineNC").bg,
      fg = utils.get_highlight("StatusLine").fg,
    }
  end
  return utils.get_highlight("DiffDelete")
end

return {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  utils.surround({ "█", "█" }, function()
    --- red if no treesitter
    local active = hl().bg
    local inactive = utils.get_highlight("StatusLineNC").bg
    return require("dko.heirline.utils").hl(active, inactive)
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
            return require("dko.heirline.utils").hl(
              { fg = color, bg = hl().bg },
              "StatusLineNC"
            )
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
        return require("dko.heirline.utils").hl(hl(), "StatusLineNC")
      end,
    },
  }),
}
