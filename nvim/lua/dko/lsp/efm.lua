---@alias ft string

---@type { [ft]: table }
local languages = {}
languages["html"] = {
  require("efmls-configs.formatters.prettier"),
}
languages["javascript"] = {
  require("efmls-configs.formatters.prettier"),
}
languages["javascriptreact"] = languages["javascript"]
languages["json"] = {
  require("efmls-configs.formatters.prettier"),
}
languages["lua"] = {
  require("efmls-configs.formatters.stylua"),
}
languages["python"] = {
  require("efmls-configs.formatters.black"),
}
languages["sh"] = {
  require("efmls-configs.linters.bashate"),
  require("efmls-configs.linters.shellcheck"),
  require("efmls-configs.formatters.shfmt"),
}
languages["typescript"] = languages["javascript"]
languages["typescriptreact"] = languages["typescript"]
languages["vim"] = {
  require("efmls-configs.linters.vint"),
}
languages["yaml"] = {
  -- root marker will narrow to .github/
  require("efmls-configs.linters.actionlint"),
  -- yamlls linting is disabled in favor of this
  require("efmls-configs.linters.yamllint"),
}

---@type ft[]
local filetypes = vim.tbl_keys(languages)

return {
  filetypes = filetypes,
  languages = languages,
}
