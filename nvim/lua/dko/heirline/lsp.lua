return {
  condition = require("heirline.conditions").lsp_attached,
  update = {
    "LspAttach",
    "LspDetach",
    "User LspProgressUpdate",
    "User LspRequest",
  },
  provider = function()
    local data = require("dko.lsp").status_progress({ bufnr = 0 })
    if data then
      return " " .. data.bar .. " " .. data.lowest.name .. " "
    end
    return ""
  end,
  hl = "dkoStatusKey",
}
