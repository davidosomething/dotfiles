local uis = vim.api.nvim_list_uis()
local ui = uis[1] or { width = 80 }

return {
  provider = function(self)
    local extraparts = {
      --2 + 1, -- search symbol
      --2 + self.search_contents:len(), -- term padding
      2 + 5, -- counts
      8, -- icon and root text
      2 + 1, -- branch indicator
      self.branch:len(), -- branch
      2 + 7, -- clipboard indicator
      2 + 1, -- remote indicator
    }
    local extrachars = 0
    for _, len in pairs(extraparts) do
      extrachars = extrachars + len
    end

    local remaining = ui.width - extrachars
    local cwd = vim.fn.fnamemodify(self.cwd, ":~")
    local output = cwd:len() < remaining and cwd or vim.fn.pathshorten(cwd)
    return ("  %s "):format(output)
  end,
  hl = "StatusLineNC",
}
