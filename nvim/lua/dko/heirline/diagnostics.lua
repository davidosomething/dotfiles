local conditions = require("heirline.conditions")

return {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },

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
    provider = function(self)
      if self.errors > 0 then
        return " " .. self.error_icon .. self.errors .. " "
      end
      return self.total - self.errors > 0 and "" or " "
    end,
    hl = "DiagnosticError",
  },
  {
    provider = function(self)
      if self.warnings > 0 then
        return " " .. self.warn_icon .. self.warnings
      end
      return self.info + self.hints > 0 and "" or " "
    end,
    hl = "DiagnosticWarn",
  },
  {
    provider = function(self)
      if self.info > 0 then
        return " " .. self.info_icon .. self.info
      end
      return self.hints > 0 and "" or " "
    end,
    hl = "DiagnosticInfo",
  },
  {
    provider = function(self)
      return self.hints > 0 and (" " .. self.hint_icon .. self.hints .. " ")
    end,
    hl = "DiagnosticHint",
  },
  {
    provider = function(self)
      return self.total == 0 and "  "
    end,
    hl = "dkoStatusGood",
  },
}
