local M = {}

M.is_loaded = function(name)
  local plugin = require("lazy.core.config").plugins[name]
  return type(plugin) == "table" and plugin._.loaded ~= nil
end

return M
