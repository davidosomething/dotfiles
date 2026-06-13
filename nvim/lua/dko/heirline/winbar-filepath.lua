-- =========================================================================
-- path
-- =========================================================================

return {
  condition = function(self)
    return (vim.bo.buftype == "" or vim.bo.buftype == "help")
      and self.filepath ~= ""
  end,
  provider = function(self)
    local dkopath = require("dko.utils.path")
    local win_width = vim.api.nvim_win_get_width(0)
    local extrachars = 3 + vim.bo.filetype:len()
    local remaining = win_width - extrachars

    local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")
    local path = vim.fn.fnamemodify(self.filepath, ":~:h")
    local rd = dkopath.relative_display(cwd, path)

    vim.b.cwd_relative_levels = rd and rd.levels
    vim.b.cwd_relative_b = rd and rd.relative

    local final
    if not rd then
      final = dkopath.compact_dir(path, 0, remaining)
    elseif rd.relative == "" then
      final = "."
    else
      local slash = vim.startswith(rd.relative, "/") and "" or "/"
      final = ("%s%s%s"):format(
        rd.up,
        slash,
        dkopath.compact_dir(rd.relative, 0, remaining)
      )
    end
    return ("in %s%s/ "):format("%<", final)
  end,
  hl = function()
    return require("dko.heirline.utils").hl("Comment")
  end,
}
