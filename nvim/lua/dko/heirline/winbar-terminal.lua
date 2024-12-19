return {
  condition = function()
    return vim.bo.buftype == "terminal"
  end,
  provider = function()
    local dkomappings = require("dko.mappings")
    return (" [%s hide] [%s mode] "):format(
      dkomappings.toggleterm.hide,
      dkomappings.toggleterm.mode
    )
  end,
  hl = "StatusLine",
}
