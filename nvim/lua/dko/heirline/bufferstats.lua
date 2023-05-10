return {
  init = function(self)
    self.all = vim.api.nvim_list_bufs()

    self.normal = vim.tbl_filter(function(bufnr)
      return not require("dko.utils.buffer").is_special(bufnr)
    end, self.all)

    self.modified = vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "modified")
    end, self.normal)
  end,
  {
    provider = "  ",
    hl = "StatusLineNC",
  },
  {
    provider = function(self)
      return ("%d"):format(#self.modified)
    end,
    hl = function(self)
      return #self.modified > 0 and "TODO" or "StatusLineNC"
    end,
  },
  {
    provider = function(self)
      return ("/%d"):format(#self.normal)
    end,
    hl = "StatusLineNC",
  },
}
