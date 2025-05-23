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
    local extrachars = 3 + self.filetype_text:len()
    local remaining = win_width - extrachars

    local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")
    local path = vim.fn.fnamemodify(self.filepath, ":~:h")
    local cwd_relative = dkopath.common_root(cwd, path)

    vim.b.cwd_relative_levels = cwd_relative.levels
    vim.b.cwd_relative_b = cwd_relative.b

    local final
    local no_common_root = cwd_relative.root == ""
    if no_common_root then
      final = dkopath.fit(remaining, path)
    else
      local in_cwd = cwd_relative.b == ""
      if in_cwd then
        final = "."
      else
        local up = cwd_relative.levels == 0 and "."
          or ("…%d"):format(cwd_relative.levels)
        local slash = vim.startswith(cwd_relative.b, "/") and "" or "/"
        final = ("%s%s%s"):format(
          up,
          slash,
          dkopath.fit(remaining, cwd_relative.b)
        )
      end
    end
    return ("in %s%s/ "):format("%<", final)
  end,
  hl = function()
    return require("dko.heirline.utils").hl("Comment")
  end,
}
