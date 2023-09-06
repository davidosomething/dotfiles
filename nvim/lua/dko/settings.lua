-- Observable settings object

local object = require("dko.utils.object")

local settings = {
  colors = {
    dark = "meh",
    light = "two-firewatch",
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
  return object.get(settings, path)
end

M.set = function(path, value)
  local current = M.get(path)
  local success = object.set(settings, path, value)
  if success and value ~= current then
    local watchers = M.watchers[path]
    vim.iter(watchers):each(function(cb)
      cb({
        path = path,
        prev = current,
        value = value,
      })
    end)
  end
end

return M
