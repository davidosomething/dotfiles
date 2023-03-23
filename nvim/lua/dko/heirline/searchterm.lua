return {
  condition = function(self)
    return self.search_contents and self.search_contents:len() > 0
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
      return (" %d/%d "):format(self.search_count.current, self.search_count.total)
    end,
    hl = "dkoStatusValue",
  },
}
