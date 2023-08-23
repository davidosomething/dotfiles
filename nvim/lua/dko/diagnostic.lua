local M = {}

-- Symbols in signs column
--  ✕ ✖ ✘ ‼   ❢ ❦ ‽    ⁕ ⚑ ✔  ✎
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
M.SIGNS = { Error = "✘", Warn = "", Info = "⚑", Hint = "" }
M.SEVERITY_TO_SYMBOL = {}
for type, icon in pairs(M.SIGNS) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon .. " ", texthl = hl, numhl = hl })

  local key = type:upper()
  local code = vim.diagnostic.severity[key]
  M.SEVERITY_TO_SYMBOL[code] = icon
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

  -- diagnostic.message may be pre-parsed in an lspconfig's handlers
  -- ["textDocument/publishDiagnostics"]
  -- e.g. tsserver in dko/plugins/lsp.lua

  local symbol = M.SEVERITY_TO_SYMBOL[diagnostic.severity] or "-"
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
  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,
  float = {
    border = "rounded",
    header = false, -- remove the line that says 'Diagnostic:'
    source = false, -- hide it since my float_format will add it
    format = float_format, -- can customize more colors by using prefix/suffix instead
    suffix = "", -- default is error code. Moved to message via float_format
  },
  update_in_insert = false, -- wait until insert leave to check diagnostics
})

return M
