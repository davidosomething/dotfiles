---@class dko.LazySpecContext
---@field has_ui boolean
---@field is_giteditor boolean

---@param fn fun(ctx: dko.LazySpecContext): LazySpec
---@return LazySpec
return function(fn)
  local uis = vim.api.nvim_list_uis()
  local has_ui = #uis > 0
  local is_giteditor = vim.env.DKO_EDITOR_CONTEXT == "giteditor"
  return fn({ has_ui = has_ui, is_giteditor = is_giteditor })
end
