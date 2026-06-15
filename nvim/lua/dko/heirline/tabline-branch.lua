local utils = require("heirline.utils")

return {
  condition = function(self)
    return self.branch:len() > 0
  end,
  utils.surround({ "█", "" }, function()
    return utils.get_highlight("StatusLineNC").bg
  end, {
    provider = function(self)
      if not self.branch then
        return
      end
      local segments = vim.split(self.branch, "/", { plain = true })
      for i, segment in ipairs(segments) do
        if segment == vim.env.USER then
          segments[i] = "👤"
        elseif #segment > 16 then
          segments[i] = segment:sub(1, 16) .. "…"
        end
      end
      self.branch = table.concat(segments, "/")
      return (" %s"):format(self.branch)
    end,
  }),
}
