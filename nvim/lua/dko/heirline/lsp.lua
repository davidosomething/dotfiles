return {
  condition = function()
    local conditions = require("heirline.conditions")
    return conditions.lsp_attached() and conditions.is_active()
  end,
  update = {
    "LspAttach",
    "LspDetach",
    "User LspProgressUpdate",
    "User LspRequest",
  },
  provider = function()
    local data = require("everandever.lsp").status_progress({ bufnr = 0 })
    return data and (" %s %s "):format(data.bar, data.lowest.name) or ""
  end,
  hl = "dkoStatusKey",
}
