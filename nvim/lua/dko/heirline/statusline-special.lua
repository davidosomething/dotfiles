return {
  condition = function()
    return require("heirline.conditions").buffer_matches({
      buftype = require("dko.utils.buffer").SPECIAL_BUFTYPES,
      filetype = require("dko.utils.buffer").SPECIAL_FILETYPES,
    })
  end,
}
