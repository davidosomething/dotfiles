local M = {}

M.select_nearest = function()
  local vt_ok, vt = pcall(require, "various-textobjs")
  if not vt_ok then
    return false
  end

  -- visually select URL
  vt.url()
  -- did we switch to visual mode and highlight a url?
  -- this works since the plugin switched to visual mode
  ---@type integer | nil
  local textobj_url = vim.fn.mode():find("v")
  return textobj_url ~= nil
end

return M
