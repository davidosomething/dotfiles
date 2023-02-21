return {
  provider = "%=",
  hl = function()
    return require("heirline.conditions").is_active() and "StatusLine"
      or "StatusLineNC"
  end,
}
