local M = {}

-- ===========================================================================
-- LSP Notifications
-- ===========================================================================

local notify_opts = {
  title = "LSP",
  render = "compact",
}

---Hooked into null_ls runtime_conditions to notify on run
---@param params table
M.null_ls_notify_on_format = function(params)
  local source = params:get_source()
  vim.notify(
    ("null-ls[%s] format"):format(source.name),
    vim.log.levels.INFO,
    notify_opts
  )
end

-- ===========================================================================
-- LSP coordination - make sure null-ls and real lsps play nice
-- ===========================================================================

local format_timeout = 500

M.get_active_client = function(needle)
  local ok, lutil = pcall(require, "lspconfig.util")
  return ok and lutil.get_active_client_by_name(0, needle)
end

---Find a null-ls source
---@param needle string
---@return table|nil source
M.get_source = function(needle)
  local ok, ns = pcall(require, "null-ls.sources")
  local sources = ok and ns.get_available(vim.bo.filetype) or {}
  for _, source in pairs(sources) do
    if source.name == needle then
      return source
    end
  end
  return nil
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

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
M.format_jsts = function()
  local queue = {}

  local prettier_source = M.get_source("prettier")
  if prettier_source then
    -- skip null-ls prettier formatting if has eslint-plugin-prettier
    local has_epp = M.has_eslint_plugin_prettier()
    if has_epp then
      vim.notify(
        "null-ls[prettier] prefer eslint-plugin-prettier",
        vim.log.levels.INFO,
        notify_opts
      )
    else
      table.insert(queue, M.format_with_null_ls)
    end
  end

  local eslint = M.get_active_client("eslint")
  if eslint then
    table.insert(queue, function()
      vim.notify("eslint.applyAllFixes", vim.log.levels.INFO, notify_opts)
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
      -- @TODO move this somewhere better
      -- =====================================================================

      if vim.tbl_contains({ "lua_ls" }, client.name) then
        vim.notify(
          ("%s formatting skipped"):format(client.name),
          vim.log.levels.INFO,
          notify_opts
        )
        return false
      end

      -- =====================================================================
      -- My null-ls runtime_condition will notify
      -- This will notify for other LSPs
      -- =====================================================================

      if client.name ~= "null-ls" then
        vim.notify(
          ("%s format"):format(client.name),
          vim.log.levels.INFO,
          notify_opts
        )
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

-- ===========================================================================

return M
