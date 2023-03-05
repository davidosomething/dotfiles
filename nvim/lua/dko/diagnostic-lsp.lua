local M = {}

-- Symbols in signs column
--    ✕ ✖ ✘   ‼   ❢ ❦ ‽   ⁕ ⚑ ✔   ✎
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
  local sourceText = require("dko.utils.string").smallcaps("<" .. source .. ">")
  return symbol .. " " .. diagnostic.message .. " " .. sourceText
end

vim.diagnostic.config({
  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,
  float = {
    border = "rounded",
    header = false, -- remove the line that says 'Diagnostic:'
    source = false, -- hide it since my floatFormat will add it
    format = floatFormat, -- can customize more colors by using prefix/suffix instead
  },
  update_in_insert = false, -- wait until insert leave to check diagnostics
})

-- ===========================================================================
-- LSP borders
-- Add default rounded border and suppress no info messages
-- E.g. used by /usr/share/nvim/runtime/lua/vim/lsp/handlers.lua
-- To see example of this fn used, press K for LSP hover
-- Overriding with vim.lsp.with is the way recommended by docs (as opposed to
-- overriding vim.lsp.util.open_floating_preview entirely)
-- ===========================================================================

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  -- suppress 'No information available' notification (nvim-0.9 ?)
  -- https://github.com/neovim/neovim/pull/21531/files#diff-728d3ae352b52f16b51a57055a3b20efc4e992efacbf1c34426dfccbba30037cR339
  silent = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    -- suppress 'No information available' notification (nvim-0.8!)
    silent = true,
  })

return M
