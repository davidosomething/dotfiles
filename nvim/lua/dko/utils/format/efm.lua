local Methods = vim.lsp.protocol.Methods

local toast = require("dko.utils.notify").toast

local M = {}

M.format = function(opts)
  opts = opts or {}

  -- need to check for client in case we did :LspStop or something
  local client = vim.lsp.get_clients({ bufnr = 0, name = "efm" })[1]
  if not client then
    return
  end

  if not opts.hide_notification then
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

    local title = "[LSP] efm"
    if opts.pipeline then
      title = ("[LSP] %s > efm"):format(opts.pipeline)
    end
    toast(("%s"):format(formatters), vim.log.levels.INFO, {
      group = "format",
      title = title,
      render = "compact",
    })
  end

  vim.lsp.buf.format({
    async = false,
    name = "efm",
    timeout_ms = vim.env.SSH_CLIENT and 3000 or 1000,
  })
end

--- Assuming each
--- Temporarily removes all efm configs except the one named
--- Runs lsp format synchronously
--- Then restores the original efm configs
---@param name string formatter name, e.g. markdownlint
---@param opts? table
M.format_with = function(name, opts)
  opts = opts or {}

  local title = opts.pipeline and ("[LSP] %s > efm"):format(opts.pipeline)
    or "[LSP] efm"

  local client = vim.lsp.get_clients({ bufnr = 0, name = "efm" })[1]
  if not client then
    toast(
      "efm not attached",
      vim.log.levels.ERROR,
      { title = title, group = "format", render = "compact" }
    )
    return
  end

  local configs = require("dko.tools").get_efm_languages(function(tool)
    return tool.name == name and vim.tbl_contains(tool.fts, vim.bo.filetype)
  end)
  if vim.tbl_count(configs) == 0 then
    toast(
      ("No formatter %s for %s"):format(name, vim.bo.filetype),
      vim.log.levels.ERROR,
      { title = title, group = "format", render = "compact" }
    )
    return
  end

  ---@type (EfmFormatter|EfmLinter)[]
  local original = client.config.settings.languages
  local only = configs

  -- Set to only the efm tool we named
  client.config.settings.languages = only
  client.notify(
    Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )

  -- Do the deed
  toast(
    ("Formatting with %s"):format(name),
    vim.log.levels.INFO,
    { title = title, group = "format", render = "compact" }
  )
  M.format({ hide_notification = true })

  -- Restore original config
  client.config.settings.languages = original
  client.notify(
    Methods.workspace_didChangeConfiguration,
    { settings = client.config.settings }
  )
end

return M
