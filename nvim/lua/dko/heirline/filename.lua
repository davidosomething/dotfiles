return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,

  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return " ᴜɴɴᴀᴍᴇᴅ "
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    --[[ if
      not require("heirline.conditions").width_percent_below(#filename, 0.50)
    then
      filename = vim.fn.pathshorten(filename)
    end ]]
    return " " .. filename .. " "
  end,
  hl = function()
    return require("heirline.conditions").is_active() and "StatusLine"
      or "StatusLineNC"
  end,
}
