return {
  provider = function()
    if _G.NvimLightbulb == nil then
      return ""
    end
    local _, value = pcall(_G.NvimLightbulb.get_status_text)
    if value == "" then
      return ""
    else
      return "  "
    end
  end,
  hl = function()
    return require("dko.heirline.utils").hl("DiagnosticSignWarn")
  end,
}
