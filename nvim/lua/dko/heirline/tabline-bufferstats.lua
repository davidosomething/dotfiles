return {
  init = function(self)
    self.normal = require("dko.utils.buffers").get_normal()

    self.modified = vim.tbl_filter(function(bufnr)
      return vim.bo[bufnr].modified
    end, self.normal)
  end,
  {
    provider = function(self)
      return (" 󰤌 %d"):format(#self.modified)
    end,
    hl = function(self)
      return {
        fg = require("heirline.utils").get_highlight(
          #self.modified > 0 and "WarningMsg" or "StatusLineNC"
        ).fg,
      }
    end,
  },
  {
    provider = function(self)
      return ("/%d"):format(#self.normal)
    end,
  },
}
