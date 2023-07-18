-- Code formatting pipelines

local M = {}

local format_with = function(name)
  local opts = {
    async = false,
    name = name or "null-ls",
    timeout_ms = os.getenv("SSH_CLIENT") and 3000 or 1000,
  }
  vim.lsp.buf.format(opts)
end

-- Check if resolved eslint config for bufname contains prettier/prettier
local has_eslint_plugin_prettier = function()
  local eslint = require("dko.node").get_bin("eslint")
  if not eslint then
    return false
  end

  -- No benefit to doing this async because formatting synchronously anyway
  return #vim.fn.systemlist(
    ("%s --print-config %s | grep prettier/prettier"):format(
      eslint,
      vim.api.nvim_buf_get_name(0)
    )
  ) > 0
end

local format_with_eslint = function()
  vim.cmd.EslintFixAll()
end

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
local format_jsts = function()
  vim.b.has_eslint = vim.b.has_eslint or M.get_active_client("eslint") ~= nil

  if vim.b.has_prettier == nil then
    local prettier_source = M.get_null_ls_source({
      name = "prettier",
      filetype = vim.bo.filetype,
    })
    vim.b.has_prettier = #prettier_source > 0
  end

  if vim.b.has_prettier and not vim.b.has_eslint then
    vim.notify(
      "prettier only: no eslint",
      vim.log.levels.INFO,
      { title = "LSP Format", render = "compact" }
    )
    format_with("null-ls")
  end

  if vim.b.has_eslint then
    if not vim.b.has_prettier then
      vim.notify(
        "eslint only: no prettier",
        vim.log.levels.INFO,
        { title = "LSP Format", render = "compact" }
      )
      format_with_eslint()
      return
    end

    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier = has_eslint_plugin_prettier()
    end
  end

  -- skip null-ls prettier formatting if has eslint-plugin-prettier
  if vim.b.has_eslint_plugin_prettier then
    vim.notify(
      "eslint only: found eslint-plugin-prettier",
      vim.log.levels.INFO,
      { title = "LSP Format", render = "compact" }
    )
    format_with_eslint()
    return
  end

  if vim.b.has_eslint then
    vim.notify(
      "running eslint, then prettier",
      vim.log.levels.INFO,
      { title = "LSP Format", render = "compact" }
    )
    format_with_eslint()
  end
  format_with("null-ls")
end

-- prettier? run prettier
-- else try jsonls
local format_json = function()
  if vim.b.has_prettier == nil then
    local prettier_source = M.get_null_ls_source({
      name = "prettier",
      filetype = vim.bo.filetype,
    })
    vim.b.has_prettier = #prettier_source > 0
  end
  if vim.b.has_prettier then
    format_with("null-ls")
    return
  end

  format_with("jsonls")
end

-- ===========================================================================

local pipelines = {
  typescript = format_jsts,
  typescriptreact = format_jsts,
  javascript = format_jsts,
  javascriptreact = format_jsts,
  json = format_json,
  jsonc = format_json,
}

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  local pipeline = pipelines[vim.bo.filetype]
  if type(pipeline) == "function" then
    return pipeline()
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

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L156-L196
  vim.lsp.buf.format(options)
end

return M
