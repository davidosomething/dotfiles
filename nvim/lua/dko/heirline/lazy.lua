return {
  condition = function()
    local ok, lazy_status = pcall(require, "lazy.status")
    return ok and lazy_status.has_updates()
  end,
  provider = function()
    return " " .. require("lazy.status").updates() .. " "
  end,
  hl = "dkoStatusError",
}
