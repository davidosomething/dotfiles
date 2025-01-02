local utils = require("heirline.utils")

return {
  init = function(self)
    -- Need to check if is_git_repo because vim.g.gitsigns_head is stale if you
    -- switch to an untracked file
    self.branch = vim.g.gitsigns_head or ""
  end,

  hl = "StatusLineNC",

  utils.surround({ "█", "" }, function()
    return utils.get_highlight("StatusLine").bg
  end, require("dko.heirline.bufferstats")),

  require("dko.heirline.cwd"), -- uses branch

  {
    condition = function(self)
      return self.branch:len() > 0
    end,
    utils.surround({ "", "" }, function()
      return utils.get_highlight("StatusLine").bg
    end, {
      provider = function(self)
        return self.branch and (" %s"):format(self.branch)
      end,
      hl = function()
        local hl = utils.get_highlight("StatusLine")
        return { fg = hl.fg, bg = hl.bg }
      end,
    }),
  },

  { provider = "%=" },

  -- ===========================================================================
  -- Indicators
  -- ===========================================================================

  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
  require("dko.heirline.lazy"),
  require("dko.heirline.doctor"),
}
