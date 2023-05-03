return {
  condition = function()
    return vim.g.clipboard
  end,
  {
    provider = (" ✂ %s "):format(vim.g.clipboard.name),
    hl = "dkoStatusKey",
  }
}
