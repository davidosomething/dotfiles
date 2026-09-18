return {
  condition = function()
    return vim.fn.exists("&busy") == 1
  end,
  init = function(self)
    -- for toggleterm this is something like
    -- term://~/.dotfiles/nvim//96469:/bin/zsh;#toggleterm#88888
    self.filepath = vim.api.nvim_buf_get_name(0)
  end,
  hl = function()
    --- dko.utils.format is blocking on LSP startup, so the whole UI is frozen
    --- -- force the bar orange (same group as a running job) to show why
    if vim.b.dko_format_waiting then
      local important =
        require("heirline.utils").get_highlight("dkoLineImportant")
      return { bg = important.bg, fg = important.fg, force = true }
    end
    return require("dko.heirline.utils").hl()
  end,
  require("dko.heirline.winbar-filename"),
  require("dko.heirline.winbar-filepath"),
  require("dko.heirline.winbar-terminal"),

  { provider = "%=" },

  {
    provider = function()
      return vim.bo.busy > 0 and "◐ " or ""
    end,
  },

  require("dko.heirline.lightbulb"),
  require("dko.heirline.winbar-diagnostics"),
}
