local update = {
  "LspAttach",
  "LspDetach",
}
if vim.fn.has("nvim-0.10") == 1 then
  table.insert(update, "LspNotify")
  table.insert(update, "LspProgress")
  table.insert(update, "LspRequest")
end

return {
  condition = function()
    local conditions = require("heirline.conditions")
    return conditions.lsp_attached() and conditions.is_active()
  end,

  -- There's a temporary fix to force redraw for these autocmds in bahviors.lua
  update = update,

  provider = function()
    local ok, everandever = pcall(require, "everandever.lsp")
    local data = ok and everandever.status_progress({ bufnr = 0 })
    return data and (" %s %s "):format(data.bar, data.lowest.name) or ""
  end,
  hl = "dkoStatusKey",
}
