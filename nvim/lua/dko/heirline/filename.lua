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

    local function shorten(filename, amount)
      -- GIVEN '/abc/123/def/345/file.tsx'

      -- '/abc/123/def/345'
      -- '123/def/345' if you are already in /abc
      local short_ancestors = vim.fn.fnamemodify(filename, ":~:.:h")
      -- '12/de/34'
      short_ancestors = vim.fn.pathshorten(short_ancestors, amount)
      -- '12/de'
      short_ancestors = vim.fn.fnamemodify(short_ancestors, ':h')

      -- '345'
      local parent_dir = vim.fn.fnamemodify(filename, ":p:h:t")

      -- file.tsx
      local just_filename = vim.fn.fnamemodify(filename, ":t")

      return " "
        .. short_ancestors
        .. "/"
        .. parent_dir
        .. "/"
        .. just_filename
        .. " "
    end

    local twoshort = shorten(self.filename, 2)
    if string.len(twoshort) < remaining then
      return twoshort
    end

    return shorten(self.filename, 1)
  end,
  hl = function()
    return require("heirline.conditions").is_active() and "StatusLine"
      or "StatusLineNC"
  end,
}
