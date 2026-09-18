local M = {}

---An attached client means nvim-lspconfig's oxfmt root_dir found an
---.oxfmtrc.json/.oxfmtrc.jsonc/oxfmt.config.ts, or a package.json/vite.config.ts
---that mentions oxfmt -- i.e. this project opted into oxfmt. Cheaper than any
---package.json read or config file search, and nothing to invalidate.
---@return vim.lsp.Client|nil
M.get_client = function()
  return vim.lsp.get_clients({
    bufnr = 0,
    method = "textDocument/formatting",
    name = "oxfmt",
  })[1]
end

local function request_format()
  vim.lsp.buf.format({
    async = false, -- run_pipeline is called from BufWritePre
    name = "oxfmt",
    timeout_ms = require("dko.utils.format").timeout_ms(),
  })
end

---Format with the oxfmt LSP (`oxfmt --lsp`), if it is attached
---@param opts? { pipeline?: string }
---@return boolean -- whether oxfmt formatted the buffer
M.format = function(opts)
  opts = opts or {}

  --- Filtering on the formatting capability too, or vim.lsp.buf.format prints
  --- a raw "no matching language servers" error instead of toasting
  if not M.get_client() then
    return false
  end

  local title = opts.pipeline and ("[LSP] %s > oxfmt"):format(opts.pipeline)
    or "[LSP] oxfmt"
  require("dko.utils.notify").toast(
    "Formatting with oxfmt",
    vim.log.levels.INFO,
    { group = "format", render = "wrapped-compact", title = title }
  )

  local tick = vim.b.changedtick
  request_format()

  --- oxfmt answers with no edits at all when the request beats its didOpen,
  --- a ~50ms window after attach, so ask once more if the first request
  --- changed nothing. Costs one extra request the first time a buffer is
  --- already formatted, and nothing after that.
  if not vim.b.oxfmt_warmed then
    vim.b.oxfmt_warmed = true
    if vim.b.changedtick == tick then
      request_format()
    end
  end

  return true
end

return M
