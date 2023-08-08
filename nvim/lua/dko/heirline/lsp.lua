return {
  condition = function()
    if vim.bo.buftype == "quickfix" then
      return false
    end
    local conditions = require("heirline.conditions")
    return conditions.lsp_attached() and conditions.is_active()
  end,

  --
  -- There's a temporary fix to force redraw for these autocmds in bahviors.lua
  --
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
