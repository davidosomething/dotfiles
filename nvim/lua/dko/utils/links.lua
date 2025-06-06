local M = {}

--- @return string|nil
M.get_nearest_url = function()
  local vt_ok, vt = pcall(require, "various-textobjs")
  if not vt_ok then
    return nil
  end

  -- visually select URL
  vt.url()
  -- did we switch to visual mode and highlight a url?
  -- this works since the plugin switched to visual mode
  ---@type integer | nil
  local textobj_url = vim.fn.mode():find("v")
  return require("dko.utils.selection").get()
end

--- Follow LSP textDocument/documentLink if available
--- Uses https://github.com/icholy/lsplinks.nvim
--- @return string|nil
M.get_documentLink = function()
  local lsplinks_ok, lsplinks = pcall(require, "lsplinks")
  return lsplinks_ok and lsplinks.current() or nil
end

M.open_link = function()
  if vim.b.did_bind_coc then
    local result = vim.fn.CocAction("openLink")
    if result then
      vim.notify(
        "Opening via coc openLink",
        vim.log.levels.INFO,
        { title = "gx" }
      )
      return
    end
  end

  local url = M.get_documentLink()
  if url then
    vim.notify(
      ("Opening documentLink\n%s"):format(url),
      vim.log.levels.INFO,
      { title = "gx" }
    )
  else
    url = M.get_nearest_url()
    if url then
      vim.notify(
        ("Opening nearest URL\n%s"):format(url),
        vim.log.levels.INFO,
        { title = "gx" }
      )
    end
  end
  if url then
    vim.ui.open(url)
    return
  end

  -- Popup menu of all urls in buffer
  if vim.fn.exists(":UrlView") then
    vim.cmd.UrlView("buffer")
  end
end

return M
