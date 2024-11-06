return {
  condition = function()
    local filename = vim.fn.expand("%:t")
    return filename == "package.json"
  end,

  update = { "User", pattern = "DkoPackageInfoStatusUpdate" },

  provider = function()
    local pok, pi = pcall(require, "package-info.ui.generic.loading-status")
    if not pok then
      return ""
    end
    return pi.state.current_spinner == "" and ""
      or (" %s "):format(pi.state.current_spinner)
  end,

  hl = "Comment",
}
