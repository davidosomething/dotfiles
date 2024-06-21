local M = {}

---Notify via fidget if available
---@param msg string
---@param level? integer vim.log.levels.*
---@param opts? table
M.toast = function(msg, level, opts)
  -- use title as fidget's annote option
  opts.annote = opts and opts.title

  local found, fidget = pcall(require, "fidget")
  local notify = found and fidget.notify or vim.notify
  notify(msg, level, opts)
end

return M
