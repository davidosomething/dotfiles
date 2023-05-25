return {
  init = function(self)
    self.search_contents = vim.fn.getreg("/")
    self.search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
  end,
  {
    condition = function(self)
      return self.search_contents and self.search_contents:len() > 0
    end,

    {
      provider = function(self)
        return (" %s "):format(self.search_contents)
      end,
      hl = "Search",
    },
    {
      provider = function(self)
        return (" %d/%d "):format(
          self.search_count.current,
          self.search_count.total
        )
      end,
      hl = "StatusLine",
    },
  },
}
