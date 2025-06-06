local M = {}

M.get_nearest_url = function()
  local vt_ok, vt = pcall(require, "various-textobjs")
  if not vt_ok then
    return false
  end

  -- visually select URL
  vt.url()
  -- did we switch to visual mode and highlight a url?
  -- this works since the plugin switched to visual mode
  ---@type integer | nil
  local textobj_url = vim.fn.mode():find("v")
  return textobj_url ~= nil
end

--- Follow LSP textDocument/documentLink if available
--- Uses https://github.com/icholy/lsplinks.nvim
M.follow_documentLink = function()
  local lsplinks_ok, lsplinks = pcall(require, "lsplinks")
  if lsplinks_ok then
    local lsp_url = lsplinks.current()
    -- alternatively use vim.ui.open on lsplinks.current()
    if lsp_url then
      vim.print(("found lsp_url %s"):format(lsp_url))
      vim.ui.open(lsp_url)
      return true
    end
  end
  return false
end

M.open_link = function()
  if M.follow_documentLink() then
    return
  end

  if M.get_nearest_url() then
    local url = require("dko.utils.selection").get()
    if url then
      vim.notify(
        ("Opening nearest URL\n%s"):format(url),
        vim.log.levels.INFO,
        { title = "gx" }
      )
      vim.ui.open(url)
      return
    end
  end

  -- -------------------------------------------------------------------------
  -- Popup menu of all urls in buffer
  -- -------------------------------------------------------------------------
  if vim.fn.exists(":UrlView") then
    vim.cmd.UrlView("buffer")
  end
end

return M
