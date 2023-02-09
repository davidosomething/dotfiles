local M = {}

local map = vim.keymap.set

-- Symbols in signs column
--    ✕ ✖ ✘   ‼   ❢ ❦ ‽  ⁕
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
M.SIGNS = { Error = "✘", Warn = "", Hint = "", Info = "ɪ" }
M.SEVERITY_TO_SYMBOL = {}
for type, icon in pairs(M.SIGNS) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon .. ' ', texthl = hl, numhl = hl })

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

  local symbol = M.SEVERITY_TO_SYMBOL[diagnostic.severity] or '-'

  local source = diagnostic.source
  -- strip period at end
  if source.sub(source, -1, -1) == "." then
    source = string.sub(source, 1, -2)
  end
  local sourceText = '[' .. source .. ']'

  return ' ' .. symbol .. ' ' .. diagnostic.message .. ' ' .. sourceText .. ' '
end
vim.diagnostic.config({
  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,
  float = {
    header = false, -- remove the line that says 'Diagnostic:'
    source = false,  -- hide it since my floatFormat will add it
    format = floatFormat, -- can customize more colors by using prefix/suffix instead
  },
  update_in_insert = false, -- wait until insert leave to check diagnostics
})

local diagnosticGroup = vim.api.nvim_create_augroup('dkodiagnostic', { clear = true })
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  desc = 'Sync diagnostics to loclist',
  callback = function()
    vim.diagnostic.setloclist({ open = false })
  end,
  group = diagnosticGroup
})

-- ===========================================================================
-- Diagnostic mappings
-- ===========================================================================

local gotoOpts = {
  noremap = true,
  silent = true,
  desc = 'Go to diagnostic and open float'
}
local floatOpts = {
  focus = false,
  scope = 'cursor',
}
map('n', '[d', function()
  vim.diagnostic.goto_prev({ float = floatOpts })
end, gotoOpts)
map('n', ']d', function()
  vim.diagnostic.goto_next({ float = floatOpts })
end, gotoOpts)
map('n', '<Leader>d', function()
  vim.diagnostic.open_float(floatOpts)
end, { desc = "Open diagnostic float at cursor" })

-- ===========================================================================
-- LSP configuration
-- Mix of https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- and :h lsp
-- ===========================================================================

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Bind LSP in buffer',
  callback = function(args)
    local function lspmap(mode, lhs, rhs, additionalOpts)
      local opts = vim.tbl_extend('force', {
        noremap = true,
        silent = true,
        buffer = args.buf
      }, additionalOpts)
      map(mode, lhs, rhs, opts)
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    lspmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP declaration' })
    lspmap('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP definition' })

    if client.server_capabilities.hoverProvider then
      lspmap('n', 'K', vim.lsp.buf.hover, { desc = 'LSP hover' })
    end

    lspmap('n', 'gi', vim.lsp.buf.implementation, { desc = 'LSP implementation' })
    lspmap('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP signature_help' })
    --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --[[ map('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts) ]]
    lspmap('n', '<Leader>D', vim.lsp.buf.type_definition, { desc = 'LSP type_definition' })
    lspmap('n', '<Leader>rn', vim.lsp.buf.rename, { desc = 'LSP rename' })
    lspmap('n', '<Leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })

    lspmap('n', 'gr', vim.lsp.buf.references, { desc = 'LSP references' })

    -- prefer formatter.nvim
    --map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.api.nvim_buf_create_user_command(
      args.buf,
      'LspFormat',
      function()
        vim.lsp.buf.format({ async = false })
      end,
      { desc = "Synchronously format buffer using LSP" }
    )
    lspmap('n', '<A-=>', '<Cmd>LspFormat<CR>', { desc = 'LSP: Format buffer' })
  end,
  group = vim.api.nvim_create_augroup('dkolsp', { clear = true }),
})

-- ===========================================================================
-- LSP borders
-- ===========================================================================

vim.cmd [[autocmd! ColorScheme * highlight link NormalFloat dkoBgAlt]]
vim.cmd [[autocmd! ColorScheme * highlight link FloatBorder dkoType]]

-- Add default rounded border
-- To see example of this fn used, press K for LSP hover
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: redefined-local, duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- ===========================================================================

return M
