--- biome efm config using `format` instead of `check` and without `--apply`
return function()
  local fs = require("efmls-configs.fs")

  local formatter = "biome"
  local args = "format --write --stdin-file-path '${INPUT}'"
  local command =
    string.format("%s %s", fs.executable(formatter, fs.Scope.NODE), args)

  return {
    formatCommand = command,
    formatStdin = true,
    --- only when explicitly configured for biome
    rootMarkers = { "biome.json" },
  }
end
