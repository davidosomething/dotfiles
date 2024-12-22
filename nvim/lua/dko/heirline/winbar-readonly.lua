local hl = require("dko.heirline.utils").hl

return {
  condition = function()
    return vim.bo.buftype == "" and (not vim.bo.modifiable or vim.bo.readonly)
  end,
  provider = "  ",
  hl = function()
    return hl("dkoLineImportant")
  end,
}
