local conditions = require("heirline.conditions")
return {
  init = function(self)
    self.branch = conditions.is_git_repo()
        and vim.api.nvim_buf_get_var(0, "gitsigns_head")
      or ""

    self.cwd = vim.loop.cwd()

    self.search_contents = vim.fn.getreg("/")
    self.search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
  end,

  require("dko.heirline.searchterm"),
  { provider = "%=", hl = "StatusLine" },
  require("dko.heirline.cwd"),
  require("dko.heirline.git"),
  require("dko.heirline.lazy"),
  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
}
