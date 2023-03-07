return {
  init = function(self)
    self.cwd = vim.loop.cwd()
  end,
  {
    provider = function(self)
      local is_project_root = vim.b['dko_project_root'] == self.cwd
      return is_project_root and "  ʀᴏᴏᴛ " or "  "
    end,
    hl = "dkoStatusKey",
  },
  {
    provider = function(self)
      local uis = vim.api.nvim_list_uis()
      local ui = uis[1] or { width = 80 }
      local searchterm = vim.fn.getreg("/")
      local extrachars = 32 + string.len(searchterm)
      local remaining = ui.width - extrachars
      local cwd = vim.fn.fnamemodify(self.cwd, ":~")
      local output = string.len(cwd) < remaining and cwd or  vim.fn.pathshorten(cwd)
      return (" %s "):format(output)
    end,
    hl = "dkoStatusValue",
  },
}
