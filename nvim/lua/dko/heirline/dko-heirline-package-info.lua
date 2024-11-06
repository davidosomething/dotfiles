return {
  update = { "User", pattern = "DkoPackageInfoStatusUpdate" },

  provider = function()
    -- still buggy on their side
    local pok, pi = pcall(require, "package-info.ui.generic.loading-status")
    if not pok then
      return ""
    end
    return pi.state.current_spinner == "" and ""
      or (" %s "):format(pi.state.current_spinner)
  end,

  hl = "Comment",
}
