-- Shared utilities for mapping modules
local M = {}

---Format a mapping description
---@param feature string The feature name
---@param provider_key string The provider key
---@return string formatted_description
M.format_desc = function(feature, provider_key)
  return ("%s [%s]"):format(feature, provider_key)
end

---Get provider based on settings
---@param config table Feature configuration
---@param group? string Optional group (for LSP)
---@param finder_key? string Optional finder key override
---@return string provider_key, any provider
M.get_provider = function(config, group, finder_key)
  -- Handle COC-specific logic for LSP
  if group == "coc" and config.providers["coc"] then
    return "coc", config.providers["coc"]
  end

  -- Determine which finder key to use
  finder_key = finder_key or config.finder_key or "finder"
  local finder = require("dko.settings").get(finder_key)

  -- Select the appropriate provider
  local provider_key = config.providers[finder] and finder or "default"
  return provider_key, config.providers[provider_key]
end

return M

