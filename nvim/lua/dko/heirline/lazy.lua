return {
  condition = function()
    return require("lazy.status").has_updates()
  end,
  provider = function()
    return " " .. require("lazy.status").updates() .. " "
  end,
  hl = "dkoStatusError",
}
