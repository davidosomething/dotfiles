-- Code formatting pipelines

local M = {}

M.format_efm = function(hide_notification)
  if not hide_notification then
    local client = vim.lsp.get_clients({ bufnr = 0, name = "efm" })[1]
    local languages = client.config.settings.languages
    local configs = languages[vim.bo.filetype]
    local formatters = table.concat(
      vim
        .iter(configs)
        :filter(function(v)
          return v.formatCommand ~= nil
        end)
        :map(function(v)
          return v.formatCommand:match("(%w+)")
        end)
        :totable(),
      ", "
    )
    vim.notify(("%s"):format(formatters), vim.log.levels.INFO, {
      render = "compact",
      title = "LSP > efm",
    })
  end

  vim.lsp.buf.format({
    async = false,
    name = "efm",
    timeout_ms = os.getenv("SSH_CLIENT") and 3000 or 1000,
  })
end

--- Assuming each
--- Temporarily removes all efm configs except the one named
--- Runs lsp format synchronously
--- Then restores the original efm configs
---@param name string formatter name, e.g. markdownlint
M.efm_format_with = function(name)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "efm" })[1]
  if not client then
    vim.notify("efm not attached", vim.log.levels.ERROR, {
      render = "compact",
      title = "LSP > efm_format_with",
    })
    return
  end

  local configs = require("dko.tools").get_efm_languages(function(tool)
    return tool.name == name and vim.tbl_contains(tool.fts, vim.bo.filetype)
  end)
  if vim.tbl_count(configs) == 0 then
    vim.notify(
      ("no formatter %s for %s"):format(name, vim.bo.filetype),
      vim.log.levels.ERROR,
      {
        render = "compact",
        title = "LSP > efm_format_with",
      }
    )
    return
  end

  ---@type (EfmFormatter|EfmLinter)[]
  local original = client.config.settings.languages
  local only = configs

  -- Set to only the efm tool we named
  client.config.settings.languages = only
  client.notify(
    vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )

  -- Do the deed
  vim.notify(("%s only"):format(name), vim.log.levels.INFO, {
    render = "compact",
    title = "LSP > efm_format_with",
  })
  local HIDE_NOTIFICATION = true
  M.format_efm(HIDE_NOTIFICATION)

  -- Restore original config
  client.config.settings.languages = original
  client.notify(
    vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )
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

  M.format_efm()
end

local format_markdown = function()
  if vim.b.has_markdownlint == nil then
    vim.b.has_markdownlint = #vim.fs.find({
      ".markdownlint.json",
      ".markdownlint.jsonc",
      ".markdownlint.yaml",
    }, { limit = 1, upward = true, type = "file" })
  end
  if vim.b.has_markdownlint == true then
    M.efm_format_with("markdownlint")
  else
    M.efm_format_with("prettier")
  end
end

-- ===========================================================================

local pipelines = {
  html = M.format_efm,
  typescript = format_jsts,
  typescriptreact = format_jsts,
  javascript = format_jsts,
  javascriptreact = format_jsts,

  -- prettier-only for json(c)
  json = M.format_efm,
  jsonc = M.format_efm,

  lua = function()
    M.efm_format_with("stylua")
  end,

  markdown = format_markdown,
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

      vim.notify("format", vim.log.levels.INFO, {
        render = "compact",
        title = ("LSP > %s"):format(client.name),
      })
      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L156-L196
  vim.lsp.buf.format(options)
end

return M
