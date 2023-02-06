-- ===========================================================================
-- Diagnostic configuration
-- ===========================================================================

-- Symbols in signs column
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
local SIGNS = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local SEVERITY_TO_SYMBOL = {}
for type, icon in pairs(SIGNS) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })

  local key = string.upper(type)
  local code = vim.diagnostic.severity[key]
  SEVERITY_TO_SYMBOL[code] = icon
end

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

  local symbol = SEVERITY_TO_SYMBOL[diagnostic.severity] or '- '

  local source = diagnostic.source
  -- strip period at end
  if source.sub(source, -1, -1) == "." then
    source = string.sub(source, 1, -2)
  end
  local sourceText = '[' .. source .. ']'

  return ' ' .. symbol .. diagnostic.message .. ' ' .. sourceText .. ' '
end
vim.diagnostic.config({
  -- virtual_lines = { only_current_line = true }, -- for lsp_lines.nvim
  virtual_text = false,
  float = {
    header = false, -- remove the line that says 'Diagnostic:'
    source = false,  -- hide it since my floatFormat will add it
    format = floatFormat, -- can customize more colors by using prefix/suffix instead
  },
})


local diagnosticGroup = vim.api.nvim_create_augroup('dkodiagnostic', { clear = true })
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  desc = 'Sync diagnostics to loclist',
  callback = function()
    vim.diagnostic.setloclist({ open = false })
  end,
  group = diagnosticGroup
})

-- updatetime option is the delay until it opens
-- disable auto show float since it conflicts with lsp signatures
--[[ vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  desc = 'Show floating diagnostic under cursor',
  callback = function()
    vim.diagnostic.open_float({
      focus = false,
      scope = 'cursor',
    })
  end,
  group = diagnosticGroup
}) ]]

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
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ float = floatOpts })
end, gotoOpts)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ float = floatOpts })
end, gotoOpts)
vim.keymap.set('n', '<Leader>d', function()
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
    local bufopts = {
      noremap = true,
      silent = true,
      buffer = args.buf
    }

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)

    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    end

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --[[ vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts) ]]
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)

    --nvim-code-action-menu replaces this
    --vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

    -- prefer formatter.nvim
    --vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.api.nvim_buf_create_user_command(
      args.buf,
      'LspFormat',
      function()
        vim.lsp.buf.format({ async = true })
      end,
      {}
    )
  end,
  group = vim.api.nvim_create_augroup('dkolsp', { clear = true }),
})

-- ===========================================================================
-- LSP borders
-- ===========================================================================

vim.cmd [[autocmd! ColorScheme * highlight link NormalFloat dkoBgAlt]]
vim.cmd [[autocmd! ColorScheme * highlight link FloatBorder dkoType]]

---@diagnostic disable-next-line: unused-local
local solidBorder = {
  {"🭽", "FloatBorder"},
  {"▔", "FloatBorder"},
  {"🭾", "FloatBorder"},
  {"▕", "FloatBorder"},
  {"🭿", "FloatBorder"},
  {"▁", "FloatBorder"},
  {"🭼", "FloatBorder"},
  {"▏", "FloatBorder"},
}

-- local border_vertical   = "║"
-- local border_horizontal = "═"
-- local border_topleft    = "╔"
-- local border_topright   = "╗"
-- local border_botleft    = "╚"
-- local border_botright   = "╝"
-- local border_juncleft   = "╠"
-- local border_juncright  = "╣"

local roundedBorder = {
  {"╭", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╮", "FloatBorder"},
  {"│", "FloatBorder"},
  {"╯", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╰", "FloatBorder"},
  {"│", "FloatBorder"},
}

local borderOpts = {
  border = roundedBorder
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: redefined-local, duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or borderOpts.border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
