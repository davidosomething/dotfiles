return {
  condition = function(self)
    self.contents = vim.fn.getreg("/")
    self.count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
    return self.contents and string.len(self.contents) > 0
  end,

  {
    provider = function(self)
      if self.count.current > 0 then
        return " " .. self.count.current .. "/" .. self.count.total .. " "
      end
      return " ? "
    end,
    hl = "dkoStatusKey",
  },

  {
    provider = function(self)
      return " " .. self.contents .. " "
    end,
    hl = "Search",
  },
}
