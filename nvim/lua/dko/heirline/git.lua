return {
  condition = require("heirline.conditions").is_git_repo,

  init = function(self)
    self.branch = vim.api.nvim_buf_get_var(0, 'gitsigns_head')
  end,

  {
    condition = function(self)
      return self.branch
    end,
    provider = "  ",
    hl = "dkoStatusKey",
  },
  {
    condition = function(self)
      return self.branch
    end,
    provider = function(self)
      return " " .. self.branch .. " "
    end,
    hl = "dkoStatusValue",
  },
}
