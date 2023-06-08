local settings = {
  colors = {
    dark = 'meh',
    light = 'two-firewatch',
  },
  grepper = {
    ignore_file = vim.fn.expand("$DOTFILES") .. "/" .. "ag/dot.ignore",
  },
  heirline = {
    show_buftype = false,
  },
  treesitter = {
    -- @TODO until I update vim-colors-meh with treesitter @matches
    highlight_enabled = false,
  },
}

local M = {}

M.watchers = {}

M.get = function(path)
  return require("dko.utils.object").get(settings, path)
end

M.set = function(path, value)
  local current = M.get(path)
  local success = require("dko.utils.object").set(settings, path, value)
  if success and value ~= current then
    local watchers = M.watchers[path]
    for _, cb in pairs(watchers) do
      cb({
        path = path,
        prev = current,
        value = value,
      })
    end
  end
end

return M
