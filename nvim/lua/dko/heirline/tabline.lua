return {
  init = function(self)
    -- Need to check if is_git_repo because vim.g.gitsigns_head is stale if you
    -- switch to an untracked file
    self.branch = vim.g.gitsigns_head or ""
  end,

  hl = "StatusLineNC",

  require("dko.heirline.tabline-bufferstats"),
  require("dko.heirline.tabline-cwd"), -- uses branch
  require("dko.heirline.tabline-branch"), -- uses branch

  { provider = "%=" },

  -- ===========================================================================
  -- Indicators
  -- ===========================================================================

  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
  require("dko.heirline.lazy"),
  require("dko.heirline.doctor"),
}
