return {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " + ",
    hl = "DiffAdded",
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "  ",
    hl = "dkoLineImportant",
  },
}
