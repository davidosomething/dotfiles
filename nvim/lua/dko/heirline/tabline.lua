return {
  init = function(self)
    -- Need to check if is_git_repo because vim.g.gitsigns_head is stale if you
    -- switch to an untracked file
    self.branch = vim.g.gitsigns_head or ""
    local uis = vim.api.nvim_list_uis()
    self.ui = uis[1] or { width = 80 }
  end,

  hl = "StatusLineNC",

  require("dko.heirline.tabs"),
  require("dko.heirline.tabline-bufferstats"),
  { provider = " " },
  require("dko.heirline.tabline-cwd"), -- uses branch
  { provider = "" },
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
