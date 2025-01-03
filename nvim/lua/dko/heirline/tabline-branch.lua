local utils = require("heirline.utils")

return {
  condition = function(self)
    return self.branch:len() > 0
  end,
  utils.surround({ "█", "" }, function()
    return utils.get_highlight("StatusLineNC").bg
  end, {
    provider = function(self)
      return self.branch and (" %s"):format(self.branch)
    end,
  }),
}
