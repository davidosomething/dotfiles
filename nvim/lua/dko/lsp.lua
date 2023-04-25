local M = {}

vim.lsp.set_log_level("INFO")

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

-- ===========================================================================
-- LSP Notifications
-- ===========================================================================

---@alias MessageType
---| 1 # Error
---| 2 # Warning
---| 3 # Info
---| 4 # Log

---@alias LogLevel
---| 0 # TRACE
---| 1 # DEBUG
---| 2 # INFO
---| 3 # WARN
---| 4 # ERROR
---| 5 # OFF

---Convert an LSP MessageType to a vim.notify log level
---@param mt MessageType https://github.com/neovim/neovim/blob/7ef5e363d360f86c5d8d403e90ed256f4de798ec/runtime/lua/vim/lsp/protocol.lua
---@return LogLevel level https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_editor.lua#L44-L53
M.lsp_messagetype_to_vim_log_level = function(mt)
  local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[mt]
  return vim.log.levels[lvl]
end

M.bind_notify = function()
  ---Show LSP messages via vim.notify (but only when using nvim-notify)
  ---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, _)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local client_name = client and client.name or ctx.client_id
    local title = ("LSP > %s"):format(client_name)
    if not client then
      vim.notify(result.message, vim.log.levels.ERROR, { title = title })
    else
      local level = M.lsp_messagetype_to_vim_log_level(result.type)
      vim.notify(result.message, level, { title = title })
    end
    return result
  end
end

-- ===========================================================================
-- LSP coordination - make sure null-ls and real lsps play nice
-- ===========================================================================

local format_timeout = 500

---Find lsp client by name
---@param needle string
---@return boolean|table lsp client
M.get_active_client = function(needle)
  local ok, lutil = pcall(require, "lspconfig.util")
  return ok and lutil.get_active_client_by_name(0, needle)
end

---Find null-ls source by name
---@param query table
---@return table|nil source
M.get_null_ls_source = function(query)
  local ok, ns = pcall(require, "null-ls")
  local result = ok and ns.get_source(query) or {}
  return result
end

M.format_with_null_ls = function()
  vim.lsp.buf.format({ async = false, name = "null-ls" })
end

-- Check if resolved eslint config for bufname contains prettier/prettier
M.has_eslint_plugin_prettier = function()
  local eslint = require("dko.node").get_bin("eslint")
  if not eslint then
    return false
  end

  -- No benefit to doing this async because formatting synchronously anyway
  return #vim.fn.systemlist(
    eslint
      .. " --print-config "
      .. vim.api.nvim_buf_get_name(0)
      .. " | grep prettier/prettier"
  ) > 0
end

-- ===========================================================================
-- Formatting
-- ===========================================================================

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
M.format_jsts = function()
  local queue = {}

  local prettier_source = M.get_null_ls_source({
    name = "prettier",
    filetype = vim.bo.filetype,
  })
  if #prettier_source > 0 then
    -- skip null-ls prettier formatting if has eslint-plugin-prettier
    local has_epp = M.has_eslint_plugin_prettier()
    if has_epp then
      vim.notify(
        "skip: prefer eslint-plugin-prettier",
        vim.log.levels.INFO,
        { title = "LSP > null-ls > prettier" }
      )
    else
      table.insert(queue, M.format_with_null_ls)
    end
  end

  local eslint = M.get_active_client("eslint")
  if eslint then
    table.insert(queue, function()
      vim.notify("eslint.applyAllFixes", vim.log.levels.INFO, {
        title = "LSP > eslint",
      })
      vim.cmd.EslintFixAll()
    end)
  end

  for i, formatter in ipairs(queue) do
    -- defer with increasing time to ensure eslint runs after prettier
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.defer_fn(formatter, format_timeout * (i - 1))
  end
end

--- See options for vim.lsp.buf.format
M.format = function(options)
  if
    vim.tbl_contains(
      { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      vim.bo.filetype
    )
  then
    return M.format_jsts()
  end

  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if not client.supports_method("textDocument/formatting") then
        return false
      end

      -- =====================================================================
      -- Filetype specific choices
      -- =====================================================================

      -- This will notify for non-null-ls
      -- null-ls runtime_condition notifies on its own
      if client.name ~= "null-ls" then
        vim.notify(
          "format",
          vim.log.levels.INFO,
          { title = ("LSP > %s"):format(client.name) }
        )
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

---Hooked into null_ls runtime_conditions to notify on run
---@param params table
M.null_ls_notify_on_format = function(params)
  local source = params:get_source()
  vim.notify("format", vim.log.levels.INFO, {
    title = ("LSP > null-ls > %s"):format(source.name),
  })
end

-- ===========================================================================
-- Code Actions
-- ===========================================================================

-- taken from vim.lsp.buf
---@private
---@param bufnr integer
---@param mode "v"|"V"
---@return table {start={row, col}, end={row, col}} using (1, 0) indexing
local function range_from_selection(bufnr, mode)
  -- TODO: Use `vim.region()` instead https://github.com/neovim/neovim/pull/13896

  -- [bufnum, lnum, col, off]; both row and column 1-indexed
  local start = vim.fn.getpos("v")
  local end_ = vim.fn.getpos(".")
  local start_row = start[2]
  local start_col = start[3]
  local end_row = end_[2]
  local end_col = end_[3]

  -- A user can start visual selection at the end and move backwards
  -- Normalize the range to start < end
  if start_row == end_row and end_col < start_col then
    end_col, start_col = start_col, end_col
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  if mode == "V" then
    start_col = 1
    local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
    end_col = #lines[1]
  end
  return {
    ["start"] = { start_row, start_col - 1 },
    ["end"] = { end_row, end_col - 1 },
  }
end

-- taken from vim.lsp.buf
---@param options table|nil Optional table which holds the following optional fields:
---  - context: (table|nil)
---      Corresponds to `CodeActionContext` of the LSP specification:
---        - diagnostics (table|nil):
---                      LSP `Diagnostic[]`. Inferred from the current
---                      position if not provided.
---        - only (table|nil):
---               List of LSP `CodeActionKind`s used to filter the code actions.
---               Most language servers support values like `refactor`
---               or `quickfix`.
---  - filter: (function|nil)
---           Predicate taking an `CodeAction` and returning a boolean.
---  - apply: (boolean|nil)
---           When set to `true`, and there is just one remaining action
---          (after filtering), the action is applied without user query.
---
---  - range: (table|nil)
---           Range for which code actions should be requested.
---           If in visual mode this defaults to the active selection.
---           Table must contain `start` and `end` keys with {row, col} tuples
---           using mark-like indexing. See |api-indexing|
---
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_codeAction
M.code_action = function(options)
  local util = require("vim.lsp.util")
  vim.validate({ options = { options, "t", true } })
  options = options or {}
  -- Detect old API call code_action(context) which should now be
  -- code_action({ context = context} )
  if options.diagnostics or options.only then
    options = { options = options }
  end
  local context = options.context or {}
  if not context.triggerKind then
    context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
  end
  if not context.diagnostics then
    local bufnr = vim.api.nvim_get_current_buf()
    context.diagnostics =
      vim.lsp.diagnostic.get_line_diagnostics(bufnr, nil, nil, nil)
  end
  local params
  local mode = vim.api.nvim_get_mode().mode
  if options.range then
    assert(type(options.range) == "table", "code_action range must be a table")
    local start =
      assert(options.range.start, "range must have a `start` property")
    local end_ =
      assert(options.range["end"], "range must have a `end` property")
    params = util.make_given_range_params(start, end_)
  elseif mode == "v" or mode == "V" then
    local range = range_from_selection(0, mode)
    params = util.make_given_range_params(range.start, range["end"])
  else
    params = util.make_range_params()
  end
  params.context = context

  --code_action_request
  local bufnr = vim.api.nvim_get_current_buf()
  local method = "textDocument/codeAction"
  vim.lsp.buf_request_all(bufnr, method, params, function(results)
    --local ctx = { bufnr = bufnr, method = method, params = params }
    local action_tuples = {}
    for client_id, result in pairs(results) do
      for _, action in pairs(result.result or {}) do
        table.insert(action_tuples, { client_id, action })
      end
    end
    if #action_tuples == 0 then
      vim.notify("No code actions available", vim.log.levels.INFO)
      return
    end
    vim.print(action_tuples)
    -- local client = vim.lsp.get_client_by_id(action_tuple[1])
    -- local action = action_tuple[2]
    -- if
    --   not action.edit
    --   and client
    --   and vim.tbl_get(client.server_capabilities, 'codeActionProvider', 'resolveProvider')
    -- then
    --   client.request('codeAction/resolve', action, function(err, resolved_action)
    --     if err then
    --       vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    --       return
    --     end
    --     apply_code_action(ctx, resolved_action, client)
    --   end)
    -- else
    --   apply_code_action(ctx, action, client)
    -- end
  end)
end

---@private
M.apply_code_action = function(ctx, action, client)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  if action.command then
    local command = type(action.command) == "table" and action.command or action
    local fn = client.commands[command.command]
      or vim.lsp.commands[command.command]
    if fn then
      local enriched_ctx = vim.deepcopy(ctx)
      enriched_ctx.client_id = client.id
      fn(command, enriched_ctx)
    else
      -- Not using command directly to exclude extra properties,
      -- see https://github.com/python-lsp/python-lsp-server/issues/146
      local params = {
        command = command.command,
        arguments = command.arguments,
        workDoneToken = command.workDoneToken,
      }
      client.request("workspace/executeCommand", params, nil, ctx.bufnr)
    end
  end
end

-- ===========================================================================

return M
