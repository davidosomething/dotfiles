local icon_color_enabled = false

local keyOrOff = function()
  return require("heirline.conditions").is_active() and "dkoStatusKey"
    or "StatusLineNC"
end

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = keyOrOff,

  { -- icon
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
        filename,
        extension,
        { default = true }
      )
    end,
    provider = function(self)
      return self.icon and (" " .. self.icon)
    end,
    hl = icon_color_enabled and function(self)
      return { fg = self.icon_color }
    end or keyOrOff,
  },

  { -- filetype
    provider = function()
      if string.len(vim.bo.filetype) == 0 then
        return " "
      end
      return " "
        .. require("dko.utils.string").smallcaps(vim.bo.filetype)
        .. " "
    end,
    hl = keyOrOff,
  },
}
