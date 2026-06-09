return {
  init = function(self)
    -- for toggleterm this is something like
    -- term://~/.dotfiles/nvim//96469:/bin/zsh;#toggleterm#88888
    self.filepath = vim.api.nvim_buf_get_name(0)
  end,
  hl = function()
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
