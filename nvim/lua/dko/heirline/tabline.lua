local conditions = require("heirline.conditions")
return {
  init = function(self)
    -- Need to check if is_git_repo because vim.g.gitsigns_head is stale if you
    -- switch to an untracked file
    self.branch = conditions.is_git_repo() and vim.g.gitsigns_head or ""
  end,

  require("dko.heirline.cwd"), -- uses branch
  require("dko.heirline.git"), -- uses branch
  require("dko.heirline.bufferstats"),

  { provider = "%=", hl = "StatusLineNC" },

  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
  require("dko.heirline.lazy"),
  require("dko.heirline.doctor"),

  -- still buggy on their side
  -- require("dko.heirline.dko-heirline-package-info"),
}
