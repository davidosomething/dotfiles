local icons = require("dko.icons")

local M = {}

local sev_to_icon = {}
M.signs = { linehl = {}, numhl = {}, text = {} }

local SIGN_TYPES = { "Error", "Warn", "Info", "Hint" }
for _, type in ipairs(SIGN_TYPES) do
  local hl = ("DiagnosticSign%s"):format(type)
  local icon = icons[type]

  local key = type:upper()
  local code = vim.diagnostic.severity[key]

  -- for vim.notify icon
  sev_to_icon[code] = icon

  -- vim.diagnostic.config signs
  local sign = ("%s "):format(icon)
  M.signs.text[code] = sign
  M.signs.numhl[code] = hl

  if code == vim.diagnostic.severity.ERROR then
    -- Only colorize entire line for errors
    M.signs.linehl[code] = hl
    -- define actual sign, ALE uses it
    vim.fn.sign_define(hl, {
      linehl = hl,
      numhl = hl,
      text = M.signs.text[code],
    })
  else
    -- define actual sign, ALE uses it
    vim.fn.sign_define(hl, {
      numhl = hl,
      text = M.signs.text[code],
    })
  end
end

-- ===========================================================================
-- Diagnostic configuration
-- ===========================================================================

-- how should diagnostics show up?
local function float_format(diagnostic)
  --[[ e.g.
  {
    bufnr = 1,
    code = "trailing-space",
    col = 4,
    end_col = 5,
    end_lnum = 44,
    lnum = 44,
    message = "Line with postspace.",
    namespace = 12,
    severity = 4,
    source = "Lua Diagnostics.",
    user_data = {
      lsp = {
        code = "trailing-space"
      }
    }
  }
  ]]

  -- diagnostic.message may be pre-parsed in lspconfig's handlers
  -- ["textDocument/publishDiagnostics"]
  -- e.g. ts_ls in dko/plugins/lsp.lua

  local symbol = sev_to_icon[diagnostic.severity] or "-"
  local source = diagnostic.source
  if source then
    if source.sub(source, -1, -1) == "." then
      -- strip period at end
      source = source:sub(1, -2)
    end
  else
    source = "NIL.SOURCE"
    vim.print(diagnostic)
  end
  local source_tag =
    require("dko.utils.string").smallcaps(("%s"):format(source))
  local code = diagnostic.code and ("[%s]"):format(diagnostic.code) or ""
  return ("%s %s %s\n%s"):format(symbol, source_tag, code, diagnostic.message)
end

vim.diagnostic.config({
  -- This is a map used by vim.diagnostic but not by ALE signs
  signs = M.signs,

  -- don't create DiagnosticUnderlineWarn et al, which coc.nvim uses
  -- and looks ugly
  underline = false,

  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,

  float = {
    border = require("dko.settings").get("border"),
    header = "", -- remove the line that says 'Diagnostic:'
    source = false, -- hide it since my float_format will add it
    format = float_format, -- can customize more colors by using prefix/suffix instead
    suffix = "", -- default is error code. Moved to message via float_format
  },

  update_in_insert = false, -- wait until insert leave to check diagnostics
})

return M
