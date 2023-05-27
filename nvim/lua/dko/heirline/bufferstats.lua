return {
  condition = function()
    return not require("dko.utils.buffer").is_special(0)
  end,
  init = function(self)
    self.all = vim.api.nvim_list_bufs()

    self.normal = vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_is_loaded(bufnr) and not require("dko.utils.buffer").is_special(bufnr)
    end, self.all)

    self.modified = vim.tbl_filter(function(bufnr)
      return vim.bo[bufnr].modified
    end, self.normal)
  end,
  hl = function()
    return "StatusLineNC"
  end,
  {
    provider = function(self)
      return (" 󰤌 %d"):format(#self.modified)
    end,
    hl = function(self)
      return #self.modified > 0 and "WarningMsg" or "StatusLineNC"
    end,
  },
  {
    provider = function(self)
      return ("/%d "):format(#self.normal)
    end,
  },
}
