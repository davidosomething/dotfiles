local icons = require("dko.icons")

-- polyfill as of https://github.com/neovim/neovim/pull/26807
---@param opts? { severity?: number }
local function get_diagnostic_count(opts)
  opts = opts or {}
  if vim.diagnostic.count then
    return vim.diagnostic.count(0, opts)[0] or 0
  end
  return #vim.diagnostic.get(0, opts)
end

return {
  condition = function()
    local has_filetype = vim.bo.filetype ~= ""
    return has_filetype
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
      return (" %s %d"):format(icons.Error, self.errors)
    end,
    hl = "DiagnosticError",
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Warn, self.warnings)
    end,
    hl = "DiagnosticWarn",
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Info, self.info)
    end,
    hl = "DiagnosticInfo",
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Hint, self.hints)
    end,
    hl = "DiagnosticHint",
  },
  {
    provider = function(self)
      return self.total == 0 and (" %s "):format(icons.Ok) or " "
    end,
    hl = "dkoStatusGood",
  },
}
