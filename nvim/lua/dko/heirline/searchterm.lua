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
    condition = function(self)
      return self.count.current > 0
    end,
    provider = function(self)
      return " " .. self.count.current .. "/" .. self.count.total .. " "
    end,
    hl = "dkoStatusValue",
  },

  {
    provider = function(self)
      return " " .. self.contents .. " "
    end,
    hl = "Search",
  },
}
