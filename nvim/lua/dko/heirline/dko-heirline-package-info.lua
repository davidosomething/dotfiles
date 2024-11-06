local tick = 0

---@see https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget/spinner/patterns.lua
local triangle = {
  "◢",
  "◣",
  "◤",
  "◥",
}

return {
  condition = function()
    local filename = vim.fn.expand("%:t")
    return filename == "package.json"
  end,

  update = { "User", pattern = "DkoPackageInfoStatusUpdate" },

  provider = function()
    tick = tick + 1
    if tick > #triangle then
      tick = 1
    end
    return (" %s "):format(triangle[tick])
  end,
  hl = "dkoStatusValue",
}
