return {
  condition = function(self)
    self.contents = vim.fn.getreg("/")
    return self.contents and string.len(self.contents) > 0
  end,

  {
    provider = " ? ",
    hl = "dkoStatusKey",
  },

  {
    provider = function(self)
      return " " .. self.contents .. " "
    end,
    hl = "Search",
  },
}
