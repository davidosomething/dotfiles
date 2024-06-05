return {
  provider = function(self)
    return self.branch
      and self.branch:len() > 0
      and ("  %s "):format(self.branch)
  end,
  hl = "StatusLineNC",
}
