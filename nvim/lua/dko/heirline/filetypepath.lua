local icon_color_enabled = false

local function active_highlight(active)
  active = active or "StatusLine"
  return require("heirline.conditions").is_active() and active or "StatusLineNC"
end

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = function()
    return active_highlight()
  end,

  -- =========================================================================
  -- treesitter highlight status
  -- =========================================================================

  {
    provider = function(self)
      return self.filename == "" and "" or "  "
    end,
    hl = function()
      local enabled =
        require("dko.utils.object").get(vim.b, "ts_highlight.enabled")
      return active_highlight(enabled and "DiffAdd" or "DiffDelete")
    end,
  },

  -- =========================================================================
  -- icon
  -- =========================================================================

  {
    condition = function()
      return vim.bo.filetype ~= ""
    end,
    init = function(self)
      local extension = vim.fn.fnamemodify(self.filename, ":e")
      local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
      if ok then
        self.icon, self.icon_color = nvim_web_devicons.get_icon_color(
          self.filename,
          extension,
          { default = true }
        )
      end
    end,
    provider = function(self)
      return self.icon
          and (" %s %s "):format(
            self.icon,
            require("dko.utils.string").smallcaps(vim.bo.filetype)
          )
        or ""
    end,
    hl = function(self)
      if icon_color_enabled and self.icon_color then
        return { fg = self.icon_color }
      end
      return active_highlight("dkoStatusKey")
    end,
  },

  -- =========================================================================
  -- file path
  -- =========================================================================

  {
    provider = function(self)
      if self.filename == "" then
        return " ᴜɴɴᴀᴍᴇᴅ "
      end

      local win_width = vim.api.nvim_win_get_width(0)
      local filetype = vim.bo.filetype or ""
      local extrachars = 3 + 3 + filetype:len() + 20
      local remaining = win_width - extrachars

      local final
      local relative = vim.fn.fnamemodify(self.filename, ":~:.")
      if relative:len() < remaining then
        final = relative
      else
        local shorten = require("dko.utils.path").shorten
        local two = shorten(self.filename, 2)
        final = two:len() < remaining and two or shorten(self.filename, 1)
      end
      return " %<" .. final .. " "
    end,
    hl = function()
      return vim.bo.modified and "Todo" or active_highlight("StatusLine")
    end,
  },
}
