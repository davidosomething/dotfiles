return {
  init = function(self)
    self.cwd = vim.fn.getcwd(0)
  end,
  {
    provider = function(self)
      local is_project_root = vim.api.nvim_buf_get_var(0, "dko_project_root")
        == self.cwd
      if is_project_root then
        return "  ʀᴏᴏᴛ "
      end
      return "  "
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
      if string.len(cwd) < remaining then
        return " " .. cwd .. " "
      end
      return " " .. vim.fn.pathshorten(cwd) .. " "
    end,
    hl = "dkoStatusValue",
  },
}
