return {
  condition = function()
    return vim.bo.buftype == "terminal"
  end,
  init = function(self)
    local children = {}
    for name, mapping in pairs(require("dko.mappings").toggleterm) do
      local child = require("heirline.utils").surround(
        { "", "" },
        function()
          return require("heirline.utils").get_highlight("dkoStatusKey").bg
        end,
        {
          provider = ("󰌌 %s %s"):format(mapping, name),
          hl = "dkoStatusKey",
        }
      )
      table.insert(children, { provider = " " })
      table.insert(children, child)
    end
    self.child = self:new(children, 1)
  end,
  provider = function(self)
    return self.child:eval()
  end,
}
