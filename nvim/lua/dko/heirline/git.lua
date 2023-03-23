return {
  condition = function(self)
    return self.branch and self.branch:len() > 0
  end,
  {
    provider = "  ",
    hl = "dkoStatusKey",
  },
  {
    provider = function(self)
      return (" %s "):format(self.branch)
    end,
    hl = "dkoStatusValue",
  },
}
