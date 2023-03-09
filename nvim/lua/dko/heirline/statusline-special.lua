return {
  condition = function()
    return require("heirline.conditions").buffer_matches({
      buftype = vim.tbl_filter(function(bt)
        return bt ~= "help"
      end, require('dko.utils.buffer').SPECIAL_BUFTYPES),
      filetype = require('dko.utils.buffer').SPECIAL_FILETYPES,
    })
  end,
  require("dko.heirline.buftype"),
  require("dko.heirline.filetype"),
  require("dko.heirline.align"),
}
