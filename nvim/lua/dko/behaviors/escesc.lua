local augroup = require("dko.utils.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.listeners = {}

---Add a listener to call on <Esc><Esc><Esc>
---@TODO add a 'remove' counterpart?
---@param listener fun()
---@param desc? string
---@diagnostic disable-next-line: unused-local
M.add = function(listener, desc)
  table.insert(M.listeners, listener)
end

autocmd("User", {
  pattern = "EscEscEnd",
  callback = function()
    for _, listener in ipairs(M.listeners) do
      listener()
    end
  end,
  group = augroup("dkoescescesc"),
})

return M
