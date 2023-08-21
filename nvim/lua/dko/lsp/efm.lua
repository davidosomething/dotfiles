---@alias ft string

---@type { [ft]: table }
local languages = {}

local prettier = require("efmls-configs.formatters.prettier")

languages["html"] = { prettier }
languages["javascript"] = { prettier }
languages["javascriptreact"] = { prettier }
languages["json"] = { prettier }
languages["lua"] = { require("efmls-configs.formatters.stylua") }
languages["python"] = {
  require("efmls-configs.formatters.black"),
}
languages["sh"] = {
  require("efmls-configs.linters.bashate"),
  require("efmls-configs.linters.shellcheck"),
  require("efmls-configs.formatters.shfmt"),
}
languages["typescript"] = { prettier }
languages["typescriptreact"] = { prettier }
languages["vim"] = { require("efmls-configs.linters.vint") }
languages["yaml"] = {
  -- @TODO track https://github.com/creativenull/efmls-configs-nvim/pull/37
  -- root marker will narrow to .github/
  vim.tbl_extend(
    "force",
    require("efmls-configs.linters.actionlint"),
    { requireMarker = true, rootMarkers = { ".github/" } }
  ),
  -- yamlls linting is disabled in favor of this
  require("efmls-configs.linters.yamllint"),
}

---@type ft[]
local filetypes = vim.tbl_keys(languages)

return {
  filetypes = filetypes,
  languages = languages,
}
