-- Observable settings object
local settings = {}

---@type "none" | "bold" | "single" | "double" | "shadow" | "rounded" | "solid"
settings.pumborder = "single"

---@type "none" | "bold" | "single" | "double" | "shadow" | "rounded" | "solid"
settings.winborder = "bold"

settings.completion = {
  --- @type "blink" | "built-in" | "cmp"
  engine = "blink",
}

settings.colors = {
  -- set in ./plugins/colorscheme.lua
  --   dark = "meh",
  --   light = "zenbones",
}

settings.coc = {
  enabled = false,
  fts = require("dko.utils.table").concat(
    require("dko.utils.jsts").fts,
    { "json", "jsonc", "mdx" }
  ),
}

settings.diagnostics = {
  goto_float = true,
}

---@type 'fzf' | 'snacks'
settings.finder = "snacks"

---fzf has a preview, snacks doesn't
---@type 'fzf' | 'snacks' | 'tiny-code-action' | 'actions-preview'
settings.code_action_finder = "tiny-code-action"

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
settings.select = "snacks"

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
