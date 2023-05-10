local conditions = require("heirline.conditions")
return {
  init = function(self)
    self.branch = conditions.is_git_repo()
        and vim.api.nvim_buf_get_var(0, "gitsigns_head")
      or ""

    self.cwd = vim.loop.cwd()
  end,

  require("dko.heirline.cwd"),
  require("dko.heirline.git"),
  require("dko.heirline.bufferstats"),

  { provider = "%=", hl = "StatusLineNC" },

  require("dko.heirline.lazy"),
  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
}
