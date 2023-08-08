return {
  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },

  condition = function()
    return vim.bo.buftype ~= "quickfix"
  end,

  init = function(self)
    self.errors =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.total = self.errors + self.warnings + self.hints + self.info
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return " " .. self.error_icon .. self.errors
    end,
    hl = "DiagnosticError",
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return " " .. self.warn_icon .. self.warnings
    end,
    hl = "DiagnosticWarn",
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return " " .. self.info_icon .. self.info
    end,
    hl = "DiagnosticInfo",
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return " " .. self.hint_icon .. self.hints
    end,
    hl = "DiagnosticHint",
  },
  {
    provider = function(self)
      return self.total == 0 and "  " or " "
    end,
    hl = "dkoStatusGood",
  },
}
