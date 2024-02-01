return {
  {
    condition = function()
      return require("lazy.status").has_updates()
    end,
    {
      provider = function()
        return (" %s "):format(require("lazy.status").updates())
      end,
      hl = "Comment",
    },
  },
}
