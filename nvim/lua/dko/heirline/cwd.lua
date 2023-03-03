return {
  {
    provider = function()
      return "  "
    end,
    hl = "dkoStatusKey",
  },
  {
    provider = function()
      local cwd = vim.fn.getcwd(0)
      cwd = vim.fn.fnamemodify(cwd, ":~")
      cwd = vim.fn.pathshorten(cwd)
      local trail = cwd:sub(-1) == "/" and "" or "/"
      return " " .. cwd .. trail .. " "
    end,
    hl = "dkoStatusValue",
  },
}
