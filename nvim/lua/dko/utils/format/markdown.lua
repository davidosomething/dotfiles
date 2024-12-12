local toast = require("dko.utils.notify").toast

---@type string
local FALLBACK_FORMATTER = "" -- "prettier"

return function()
  if vim.b.has_markdownlint == nil then
    vim.b.has_markdownlint = #vim.fs.find({
      ".markdownlint.json",
      ".markdownlint.jsonc",
      ".markdownlint.yaml",
    }, { limit = 1, upward = true, type = "file" })
  end

  local formatter = FALLBACK_FORMATTER
  if vim.b.has_markdownlint == true then
    formatter = "markdownlint"
  end
  local did_efm_format = require("dko.utils.format.efm").format_with(
    formatter,
    { pipeline = "markdown" }
  )
  return did_efm_format
end
