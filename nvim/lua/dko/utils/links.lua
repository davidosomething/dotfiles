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

M.open_or_copy = function(url)
  if vim.env.DISPLAY == nil then
    vim.fn.setreg("+", url)
    vim.notify(url, vim.log.levels.INFO, { title = "Copied url" })
    return
  end
  vim.ui.open(url)
end

M.open_link = function()
  -- In plugin spec files, open plugin homepage via lazy.nvim
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:find("dko/plugins") then
    local line = vim.api.nvim_get_current_line()
    local pkg = line:match('"([%w%-_.]+/[%w%-_.]+)"')
      or line:match("'([%w%-_.]+/[%w%-_.]+)'")
    if pkg then
      local name = require("lazy.core.plugin").Spec.get_name(pkg)
      local plugin = require("lazy.core.config").plugins[name]
      if plugin and plugin.url then
        M.open_or_copy(plugin.url)
        return
      end
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
    M.open_or_copy(url)
    return
  end

  -- Popup menu of all urls in buffer
  if vim.fn.exists(":UrlView") then
    vim.cmd.UrlView("buffer")
  end
end

return M
