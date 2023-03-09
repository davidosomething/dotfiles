return {
  condition = function()
    return require('dko.settings').get('heirline.show_buftype')
  end,
  provider = function()
    return string.len(vim.bo.buftype) == 0 and ""
      or (" %s "):format(
        require("dko.utils.string").smallcaps(vim.bo.filetype)
      )
  end,
  hl = "dkoStatusItem"
}
