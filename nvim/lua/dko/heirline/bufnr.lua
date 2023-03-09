return {
  provider = function()
    return vim.api.nvim_get_current_buf()
  end,
  hl = "dkoStatusItem"
}
