-- polyfill as of https://github.com/neovim/neovim/pull/26807
function get_diagnostic_count(opts)
  opts = opts or {}
  return vim.diagnostic.count and vim.diagnostic.count(0, opts)
    or #vim.diagnostic.get(0, opts)
end

return {
  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },

  init = function(self)
    self.errors =
      get_diagnostic_count({ severity = vim.diagnostic.severity.ERROR })
    self.warnings =
      get_diagnostic_count({ severity = vim.diagnostic.severity.WARN })
    self.hints =
      get_diagnostic_count({ severity = vim.diagnostic.severity.HINT })
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
