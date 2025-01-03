return {
  provider = function(self)
    local uis = vim.api.nvim_list_uis()
    local ui = uis[1] or { width = 80 }
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
    local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")
    local shortened = cwd
    local dirs = vim.split(shortened, "/")
    local longest = 1
    for _, dir in pairs(dirs) do
      longest = dir:len() > longest and dir:len() or longest
    end
    while longest > 0 and shortened:len() > remaining do
      longest = longest - 1
      shortened = vim.fn.pathshorten(cwd, longest)
    end
    return (" %s"):format(shortened)
  end,
}
