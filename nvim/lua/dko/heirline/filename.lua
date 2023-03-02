return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,

  provider = function(self)
    if self.filename == "" then
      return " ᴜɴɴᴀᴍᴇᴅ "
    end

    local win_width = require("dko.utils.window").status_width()
    local filetype = vim.bo.filetype or ''
    local extrachars = 3 + 3 + string.len(filetype) + 20
    local remaining = win_width - extrachars
    local relative = vim.fn.fnamemodify(self.filename, ':~:.')
    if string.len(relative) < remaining then
      return " " .. relative .. " "
    end

    -- '/abc/123/def/345/file.tsx'

    -- '/abc/123/def/345'
    -- '123/def/345' if you are already in /abc
    local short_ancestors = vim.fn.fnamemodify(self.filename, ":.:h")
    -- '12/de/34'
    short_ancestors = vim.fn.pathshorten(short_ancestors, 2)
    -- '12/de'
    short_ancestors = vim.fn.fnamemodify(short_ancestors, ':h')

    -- '345'
    local parent_dir = vim.fn.fnamemodify(self.filename, ":p:h:t")

    -- file.tsx
    local filename = vim.fn.fnamemodify(self.filename, ":t")

    return " "
      .. short_ancestors
      .. "/"
      .. parent_dir
      .. "/"
      .. filename
      .. " "
  end,
  hl = function()
    return require("heirline.conditions").is_active() and "StatusLine"
      or "StatusLineNC"
  end,
}
