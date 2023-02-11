local M = {}

-- Symbols in signs column
--    ✕ ✖ ✘   ‼   ❢ ❦ ‽  ⁕ ⚑ ✔ 
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
M.SIGNS = { Error = "✘", Warn = "", Info = "⚑", Hint = "" }
M.SEVERITY_TO_SYMBOL = {}
for type, icon in pairs(M.SIGNS) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon .. " ", texthl = hl, numhl = hl })

  local key = string.upper(type)
  local code = vim.diagnostic.severity[key]
  M.SEVERITY_TO_SYMBOL[code] = icon
end

-- ===========================================================================
-- Diagnostic configuration
-- ===========================================================================

-- how should diagnostics show up?
local function floatFormat(diagnostic)
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

  local symbol = M.SEVERITY_TO_SYMBOL[diagnostic.severity] or "-"

  local source = diagnostic.source
  -- strip period at end
  if source.sub(source, -1, -1) == "." then
    source = string.sub(source, 1, -2)
  end
  local sourceText = "[" .. source .. "]"

  return " " .. symbol .. " " .. diagnostic.message .. " " .. sourceText .. " "
end
vim.diagnostic.config({
  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,
  float = {
    header = false, -- remove the line that says 'Diagnostic:'
    source = false, -- hide it since my floatFormat will add it
    format = floatFormat, -- can customize more colors by using prefix/suffix instead
  },
  update_in_insert = false, -- wait until insert leave to check diagnostics
})

-- ===========================================================================
-- LSP borders
-- ===========================================================================

vim.cmd([[autocmd! ColorScheme * highlight link NormalFloat dkoBgAlt]])
vim.cmd([[autocmd! ColorScheme * highlight link FloatBorder dkoType]])

-- Add default rounded border
-- To see example of this fn used, press K for LSP hover
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: redefined-local, duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- ===========================================================================

return M
