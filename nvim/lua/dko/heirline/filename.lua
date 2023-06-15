return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,

  provider = function(self)
    if self.filename == "" then
      return " ᴜɴɴᴀᴍᴇᴅ "
    end

    local win_width = vim.api.nvim_win_get_width(0)
    local filetype = vim.bo.filetype or ""
    local extrachars = 3 + 3 + filetype:len() + 20
    local remaining = win_width - extrachars

    local final
    local relative = vim.fn.fnamemodify(self.filename, ":~:.")
    if relative:len() < remaining then
      final = relative
    else
      local shorten = require("dko.utils.path").shorten
      local two = shorten(self.filename, 2)
      final = two:len() < remaining and two or shorten(self.filename, 1)
    end
    return " %<" .. final .. " "
  end,
  hl = function()
    if vim.bo.modified then
      return "Todo"
    end
    return require("heirline.conditions").is_active() and "StatusLine"
      or "StatusLineNC"
  end,
}
