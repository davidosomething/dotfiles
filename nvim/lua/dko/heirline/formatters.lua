-- List format-on-save clients for the buffer
return {
  condition = function()
    return vim.b.formatters ~= nil
  end,

  update = { "User", pattern = "FormattersChanged" },

  provider = function()
    return (" 󰳻 %s "):format(table.concat(vim.b.formatters, ", "))
  end,
  hl = "dkoStatusKey",
}
