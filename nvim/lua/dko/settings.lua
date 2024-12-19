-- Observable settings object

local dkoobject = require("dko.utils.object")

local settings = {
  ---@type "none" | "single" | "double" | "shadow" | "rounded"
  border = "rounded",
  colors = {
    -- set in ./plugins/colorscheme.lua
    --   dark = "meh",
    --   light = "zenbones",
  },
  coc = {
    enabled = true,
    fts = vim.tbl_extend(
      "force",
      require("dko.utils.jsts").fts,
      { "json", "jsonc" }
    ),
  },
  diagnostics = {
    goto_float = true,
  },
  ---@type 'fzf' | 'telescope'
  finder = "fzf",
  heirline = {
    show_buftype = false,
  },
}

local M = {}

M.watchers = {}

M.get = function(path)
  return dkoobject.get(settings, path)
end

M.set = function(path, value)
  local current = M.get(path)
  local success = dkoobject.set(settings, path, value)
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
