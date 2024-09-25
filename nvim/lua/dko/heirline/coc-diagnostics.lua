-- =============================================================================
-- NOT USED since we pipe to vim.diagnostic through ALE now
-- =============================================================================

local icons = require("dko.icons")

-- example vim.b.coc_diagnostic_info
-- {
--   error = 2,
--   hint = 0,
--   information = 0,
--   lnums = { 8, 0, 0, 0 },
--   warning = 0
-- }

---@param opts? { severity?: 'error' | 'hint' | 'information' | 'warning' }
local function get_diagnostic_count(opts)
  if vim.b.coc_diagnostic_info == nil then
    return 0
  end

  opts = opts or {}
  if opts.severity then
    return vim.b.coc_diagnostic_info ~= nil
      and vim.b.coc_diagnostic_info[opts.severity]
  end
  local d = vim.b.coc_diagnostic_info
  return d.error + d.warning + d.information + d.hint
end

return {
  condition = function()
    local has_filetype = vim.bo.filetype ~= ""
    if not has_filetype then
      return false
    end
    return vim.b.coc_diagnostic_info ~= nil
  end,

  init = function(self)
    self.errors = get_diagnostic_count({
      severity = "error",
    })
    self.warnings = get_diagnostic_count({
      severity = "warning",
    })
    self.hints = get_diagnostic_count({
      severity = "hint",
    })
    self.info = get_diagnostic_count({ severity = "information" })
    self.total = self.errors + self.warnings + self.hints + self.info
  end,

  update = { "User", pattern = "CocDiagnosticChange" },

  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Error, self.errors)
    end,
    hl = "DiagnosticSignError",
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Warn, self.warnings)
    end,
    hl = "DiagnosticSignWarn",
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Info, self.info)
    end,
    hl = "DiagnosticSignInfo",
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return (" %s %d"):format(icons.Hint, self.hints)
    end,
    hl = "DiagnosticSignHint",
  },
  {
    provider = function(self)
      return self.total == 0 and (" %s "):format(icons.Ok) or " "
    end,
    hl = "dkoTextGood",
  },
}
