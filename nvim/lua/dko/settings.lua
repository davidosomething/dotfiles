-- Observable settings object

local dkoobject = require("dko.utils.object")

local settings = {
  colors = {
    -- set in ./plugins/colorscheme.lua
    --   dark = "meh",
    --   light = "zenbones",
  },
  grepper = {
    ignore_file = ("%s/%s"):format(vim.env.DOTFILES, "ag/dot.ignore"),
  },
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
