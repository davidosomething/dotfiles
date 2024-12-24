local dkopath = require("dko.utils.path")
local hl = require("dko.heirline.utils").hl

-- =========================================================================
-- path
-- =========================================================================

return {
  condition = function(self)
    return (vim.bo.buftype == "" or vim.bo.buftype == "help")
      and self.filepath ~= ""
  end,
  provider = function(self)
    local win_width = vim.api.nvim_win_get_width(0)
    local extrachars = 3 + 3 + self.filetype_text:len()
    local remaining = win_width - extrachars

    local final
    local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")
    local path = vim.fn.fnamemodify(self.filepath, ":~:h")
    local cwd_relative = dkopath.common_root(cwd, path)
    local relative = vim.fn.fnamemodify(path, ":~:.") or ""

    if cwd_relative.levels < 4 and cwd_relative.root:len() < remaining then
      if cwd_relative.levels == 0 then
        if cwd_relative.b == "" then
          return "[ᴄᴡᴅ]"
        end
        final = ("%s"):format(cwd_relative.b)
      else
        local first = cwd_relative.b:sub(1, 1)
        --- if path starts with slash, it's completely rooted
        if first == "/" then
          final = cwd_relative.b
        else
          final = ("(..%d)/%s"):format(cwd_relative.levels, cwd_relative.b)
        end
      end
    elseif relative:len() < remaining then
      final = relative
    else
      local len = 8
      while len > 0 and type(final) ~= "string" do
        local attempt = vim.fn.pathshorten(path, len)
        final = attempt:len() < remaining and attempt
        len = len - 2
      end
      if not final then
        final = vim.fn.pathshorten(path, 1)
      end
    end
    return ("in %s%s/ "):format("%<", final)
  end,
  hl = function()
    return hl("Comment")
  end,
}
