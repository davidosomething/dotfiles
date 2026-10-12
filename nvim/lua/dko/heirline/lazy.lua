return {
  condition = function()
    return require("lazy.status").has_updates()
  end,
  provider = function()
    return (" %s "):format(require("lazy.status").updates())
  end,
  hl = "Comment",
  update = {
    "User",
    pattern = "LazyCheck",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawtabline()
    end),
  },
}
