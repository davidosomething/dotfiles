-- Observable settings object
local settings = {}

---@type "none" | "single" | "double" | "shadow" | "rounded"
settings.border = "rounded"

settings.colors = {
  -- set in ./plugins/colorscheme.lua
  --   dark = "meh",
  --   light = "zenbones",
}

settings.coc = {
  enabled = true,
  fts = vim.tbl_extend(
    "force",
    require("dko.utils.jsts").fts,
    { "json", "jsonc" }
  ),
}

settings.diagnostics = {
  goto_float = true,
}

---@type 'fzf' | 'snacks'
settings.finder = "snacks"

settings.heirline = {
  show_buftype = false,
}

--- @type ''|'snacks'
settings.input = "snacks" -- snacks has issues with treesitter

--- vim.print or Snacks.notifier.notify()
--- @type ''|'snacks'
settings.notify = "snacks"

--- Also the picker for vim.lsp.buf.code_action() / <leader><leader>
--- @type ''|'fzf'|'snacks'
settings.select = "fzf"

-- =============================================================================

local M = {}

M.watchers = {}

M.get = function(path)
  return require("dko.utils.object").get(settings, path)
end

M.set = function(path, value)
  local current = M.get(path)
  local success = require("dko.utils.object").set(settings, path, value)
  if success and value ~= current then
    M.watchers[path] = M.watchers[path] or {}
    vim.iter(M.watchers[path]):each(function(cb)
      cb({
        path = path,
        prev = current,
        value = value,
      })
    end)
  end
end

return M
