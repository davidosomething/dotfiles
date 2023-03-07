return {
  condition = function(self)
    self.contents = vim.fn.getreg("/")
    self.count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
    return self.contents and string.len(self.contents) > 0
  end,

  {
    provider = " ? ",
    hl = "dkoStatusKey",
  },

  {
    provider = function(self)
      return (" %s "):format(self.contents)
    end,
    hl = "Search",
  },

  {
    provider = function(self)
      return (" %d/%d "):format(self.count.current, self.count.total)
    end,
    hl = "dkoStatusValue",
  },
}
