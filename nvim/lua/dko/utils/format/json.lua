local M = {}

M.format = function()
  if require("dko.utils.format.biome").has_biome() then
    require("dko.utils.format.efm").format_with("biome", { pipeline = "json" })
  else
    require("dko.utils.format.efm").format_with(
      "prettier",
      { pipeline = "json" }
    )
  end
end

return M
