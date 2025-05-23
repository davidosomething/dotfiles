-- polyfill as of https://github.com/neovim/neovim/pull/26807
---@param opts? { severity?: number }
local function get_diagnostic_count(opts)
  opts = opts or {}
  if vim.diagnostic.count then
    return vim.diagnostic.count(0, opts)[opts.severity] or 0
  end
  return #vim.diagnostic.get(0, opts)
end

return {
  condition = function()
    return vim.bo.buftype == "" and vim.bo.filetype ~= ""
  end,

  init = function(self)
    self.errors = get_diagnostic_count({
      severity = vim.diagnostic.severity.ERROR,
    })
    self.warnings = get_diagnostic_count({
      severity = vim.diagnostic.severity.WARN,
    })
    self.hints = get_diagnostic_count({
      severity = vim.diagnostic.severity.HINT,
    })
    self.info =
      get_diagnostic_count({ severity = vim.diagnostic.severity.INFO })
    self.total = self.errors + self.warnings + self.hints + self.info
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return (" %s %d"):format(require("dko.icons").Error, self.errors)
    end,
    hl = function()
      return require("dko.heirline.utils").hl("DiagnosticSignError")
    end,
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return (" %s %d"):format(require("dko.icons").Warn, self.warnings)
    end,
    hl = function()
      return require("dko.heirline.utils").hl("DiagnosticSignWarn")
    end,
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return (" %s %d"):format(require("dko.icons").Info, self.info)
    end,
    hl = function()
      return require("dko.heirline.utils").hl("DiagnosticSignInfo")
    end,
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return (" %s %d"):format(require("dko.icons").Hint, self.hints)
    end,
    hl = function()
      return require("dko.heirline.utils").hl("DiagnosticSignHint")
    end,
  },
  {
    provider = function(self)
      return self.total == 0 and (" %s "):format(require("dko.icons").Ok) or " "
    end,
    hl = function()
      return require("dko.heirline.utils").hl("dkoTextGood")
    end,
  },
}
