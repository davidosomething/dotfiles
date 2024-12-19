return {
  condition = function()
    return vim.bo.buftype:len() > 0
  end,
  provider = function()
    return (" %s "):format(
      require("dko.utils.string").smallcaps(vim.bo.filetype)
    )
  end,
  hl = "dkoStatusItem",
}
