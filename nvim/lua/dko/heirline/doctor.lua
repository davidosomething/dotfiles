return {
  {
    condition = function ()
      return #require('dko.doctor').errors > 0
    end,
    {
      provider = "  ",
      hl = "Error",
    },
  },
  {
    condition = function ()
      return #require('dko.doctor').warnings > 0
    end,
    {
      provider = "  ",
      hl = "Comment",
    },
  }
}
