local M = {}

M.hidden_filetypes = require("dko.utils.table").concat({
  "markdown",
}, require("dko.utils.jsts").fts)

---bin/e listens on nvim.sock, or on nvim-tab-<wezterm tab id>.sock so each
---WezTerm tab gets its own instance
---@return string|nil -- the tab id, when this is a tab-scoped server
M.remote_tab_id = function()
  return vim.v.servername:match("nvim%-tab%-(%d+)%.sock$")
end

---@return boolean -- whether this instance is one of bin/e's servers
M.is_remote_server = function()
  return vim.v.servername:find("nvim%.sock$") ~= nil or M.remote_tab_id() ~= nil
end

M.hl = function(active, inactive)
  active = active or "StatusLine"
  inactive = inactive or "StatusLineNC"
  local conditions = require("heirline.conditions")
  return conditions.is_active() and active or inactive
end

return M
