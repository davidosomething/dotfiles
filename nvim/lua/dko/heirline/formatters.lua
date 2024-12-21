local utils = require("heirline.utils")
local hl = require("dko.heirline.utils").hl

-- List format-on-save clients for the buffer
return {
  condition = function()
    -- nil means NEVER registered
    return vim.b.formatters ~= nil
  end,
  {
    condition = function()
      return #vim.b.formatters == 0
    end,
    provider = " 󱃖 ",
    hl = function()
      -- empty table means probably LspStop happened
      return hl("DiffDelete")
    end,
  },

  {
    condition = function()
      return #vim.b.formatters > 0
    end,
    init = function(self)
      local children = {}
      for i, f in ipairs(vim.b.formatters) do
        local child = utils.surround({ "", "" }, function()
          return utils.get_highlight("dkoStatusKey").bg
        end, {
          provider = ("󱃖 %s"):format(f),
          hl = "dkoStatusKey",
        })
        table.insert(children, child)
        if i < #vim.b.formatters then
          table.insert(children, { provider = " " })
        end
      end
      self.child = self:new(children, 1)
    end,
    provider = function(self)
      return self.child:eval()
    end,
  },
}
