local M = {}

M.format = function(hide_notification)
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
          return vim.fn.fnamemodify(v.formatCommand:match("([^%s]+)"), ":t")
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
M.format_with = function(name)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "efm" })[1]
  if not client then
    vim.notify("efm not attached", vim.log.levels.ERROR, {
      render = "compact",
      title = "LSP > efm_format_with",
    })
    return
  end

  local configs = require("dko.tools").get_efm_languages(function(tool)
    return tool.name == name and vim.list_contains(tool.fts, vim.bo.filetype)
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
  M.format(HIDE_NOTIFICATION)

  -- Restore original config
  client.config.settings.languages = original
  client.notify(
    vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )
end

return M
