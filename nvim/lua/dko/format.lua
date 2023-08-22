-- Code formatting pipelines

local M = {}

local function efm_notify()
  local configs = require("dko.tools").get_efm_languages()[vim.bo.filetype]
  local formatters = require("dko.utils.table").filter(configs, function(v)
    return v.formatCommand ~= nil
  end)
  local formatCommand = #formatters > 0 and formatters[1].formatCommand
    or "unknown"
  local formatter = vim.fn.fnamemodify(formatCommand:match("%S+"), ":t")
  vim.notify(("format with %s"):format(formatter), vim.log.levels.INFO, {
    render = "compact",
    title = "LSP > efm",
  })
end

local function format_efm()
  efm_notify()
  vim.lsp.buf.format({
    async = false,
    name = "efm",
    timeout_ms = os.getenv("SSH_CLIENT") and 3000 or 1000,
  })
end

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
local format_jsts = function()
  vim.b.has_eslint = vim.b.has_eslint
    or #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0

  if vim.b.has_eslint then
    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier =
        require("dko.node").has_eslint_plugin("prettier/prettier")
    end

    vim.cmd.EslintFixAll()

    if vim.b.has_eslint_plugin_prettier then
      vim.notify("format with eslint+prettier/prettier", vim.log.levels.INFO, {
        render = "compact",
        title = "LSP > eslint",
      })
      return
    else
      vim.notify("format", vim.log.levels.INFO, {
        render = "compact",
        title = "LSP > eslint",
      })
    end
  end

  format_efm()
end

-- ===========================================================================

local pipelines = {
  html = format_efm,
  typescript = format_jsts,
  typescriptreact = format_jsts,
  javascript = format_jsts,
  javascriptreact = format_jsts,
  json = format_efm,
  jsonc = format_efm,
}

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  local pipeline = pipelines[vim.bo.filetype]
  if type(pipeline) == "function" then
    return pipeline()
  end

  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if
        not client.supports_method(
          vim.lsp.protocol.Methods.textDocument_formatting
        )
      then
        return false
      end

      -- This will notify for non-null-ls
      -- null-ls runtime_condition notifies on its own
      if client.name ~= "null-ls" then
        if client.name == "efm" then
          efm_notify()
        else
          vim.notify("format", vim.log.levels.INFO, {
            render = "compact",
            title = ("LSP > %s"):format(client.name),
          })
        end
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L156-L196
  vim.lsp.buf.format(options)
end

return M
