return {
  provider = function()
    return vim.bo.buftype:len() == 0 and ""
      or (" %s "):format(require("dko.utils.string").smallcaps(vim.bo.filetype))
  end,
  hl = "dkoStatusItem",
}
