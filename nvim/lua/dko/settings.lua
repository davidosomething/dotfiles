-- Observable settings object

local object = require("dko.utils.object")

local settings = {
  colors = {
    dark = "meh",
    light = "two-firewatch",
  },
  grepper = {
    ignore_file = ("%s/%s"):format(vim.fn.expand("$DOTFILES"), "ag/dot.ignore"),
  },
  heirline = {
    show_buftype = false,
  },
  treesitter = {
    -- ft to treesitter parser
    aliases = {
      dotenv = "bash",
      javascriptreact = "jsx",
      tiltfile = "starlark",
      typescriptreact = "tsx",
    },
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
