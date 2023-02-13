local M = {}

local function starts_with(haystack, needle)
  return string.sub(haystack, 1, string.len(needle)) == needle
end

-- Convert native vim.notify messages to nvim-notify
---@param config table
---@return function replacement for vim.notify
M.setup = function(config)
  local notify = config.notify or vim.notify

  local override = function (msg, level, opts)
    if not opts then opts = {} end
    if not opts.title then
      if starts_with(msg, '[LSP]') then
        msg = msg:gsub("%[LSP%]", "")
        opts.title = "LSP"
      end
    end
    notify(msg, level, opts)
  end

  return override
end

return M
