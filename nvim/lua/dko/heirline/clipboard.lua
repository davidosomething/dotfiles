return {
  condition = function()
    return vim.g.clipboard ~= nil
  end,
  provider = function()
    return (" 󱘝 %s "):format(vim.g.clipboard.name)
  end,
  hl = "dkoStatusKey",
}
