local M = {}

---@return EfmFormatter
M.efm = function()
  return require("efmls-configs.formatters.prettier")
end

--@TODO remove after  fixed
--https://github.com/creativenull/efmls-configs-nvim/issues/161#issuecomment-3481523557
M.working_snapshot = function()
  local fs = require("efmls-configs.fs")

  local formatter = "prettier"
  local command = string.format(
    "%s --stdin --stdin-filepath '${INPUT}' ${--range-start:charStart} "
      .. "${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}",
    fs.executable(formatter, fs.Scope.NODE)
  )

  return {
    formatCanRange = true,
    formatCommand = command,
    formatStdin = true,
    rootMarkers = {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json5",
      ".prettierrc.mjs",
      ".prettierrc.cjs",
      ".prettierrc.toml",
      "prettier.config.js",
      "prettier.config.cjs",
      "prettier.config.mjs",
    },
  }
end

return M
