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
  -- @TODO still getting a false positive match on this...
  -- rootMarkers and requireMarker are suppsoed to narrow to files in .github/ only
  -- @SEE https://github.com/mattn/efm-langserver/issues/257
  -- require("efmls-configs.linters.actionlint"),

  -- yamlls linting is disabled in favor of this
  require("efmls-configs.linters.yamllint"),
}

---@type ft[]
local filetypes = vim.tbl_keys(languages)

return {
  filetypes = filetypes,
  languages = languages,
}
