local M = {}

-- ===========================================================================
-- LSP coordination - make sure null-ls and real lsps play nice
-- ===========================================================================

---Find null-ls source by name
---@param query table
---@return table|nil source
M.get_null_ls_source = function(query)
  local ok, ns = pcall(require, "null-ls")
  local result = ok and ns.get_source(query) or {}
  return result
end

---Hook into null_ls runtime_conditions to notify on run
M.bind_formatter_notifications = function(provider)
  return provider.with({
    runtime_condition = function(params)
      local source = params:get_source()
      vim.notify("format", vim.log.levels.INFO, {
        title = ("LSP > null-ls > %s"):format(source.name),
        render = "compact",
      })

      local original = provider.runtime_condition
      return type(original) == "function" and original() or true
    end,
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
