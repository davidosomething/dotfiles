local keyOrOff = function()
  return require("heirline.conditions").is_active() and "dkoStatusKey"
    or "StatusLineNC"
end

return {
  condition = require("heirline.conditions").lsp_attached,
  update = {
    "LspAttach",
    "LspDetach",
    "User LspProgressUpdate",
    "User LspRequest",
  },
  provider = function()
    local data = require("everandever.lsp").status_progress({ bufnr = 0 })
    if data then
      return " " .. data.bar .. " " .. data.lowest.name .. " "
    end
    return ""
  end,
  hl = keyOrOff
}
