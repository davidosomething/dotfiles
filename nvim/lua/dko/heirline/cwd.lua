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
      if not require("heirline.conditions").width_percent_below(#cwd, 0.25) then
        cwd = vim.fn.pathshorten(cwd)
      end
      local trail = cwd:sub(-1) == "/" and "" or "/"
      return ' ' .. cwd .. trail .. " "
    end,
    hl = "dkoStatusValue",
  },
}
