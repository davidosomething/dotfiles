return function()
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
