return {
  {
    provider = function()
      return "  "
    end,
    hl = "dkoStatusKey",
  },
  {
    provider = function()
      local uis = vim.api.nvim_list_uis()
      local ui = uis[1] or { width = 80 }

      local searchterm = vim.fn.getreg("/")
      local extrachars = 20 + string.len(searchterm)
      local remaining = ui.width - extrachars

      local cwd = vim.fn.getcwd(0)
      cwd = vim.fn.fnamemodify(cwd, ":~")
      if string.len(cwd) < remaining then
        return " " .. cwd .. " "
      end

      cwd = vim.fn.pathshorten(cwd)
      return " " .. cwd .. " "
    end,
    hl = "dkoStatusValue",
  },
}
