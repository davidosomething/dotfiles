local dkozshnameddirs = require("dko.zsh.nameddirs")
local dkopath = require("dko.utils.path")

return {
  provider = function(self)
    local full_cwd = vim.uv.cwd() or ""
    local found = dkozshnameddirs.find(full_cwd)
    local shortname = found and found.name
    local prefix = found and found.path

    -- remove prefix and trailing slash
    local compact = (shortname and prefix and full_cwd:sub(prefix:len() + 2))
      or vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")

    _G.cwd = {
      full_cwd = full_cwd,
      shortname = shortname,
      prefix = prefix,
      compact = compact,
    }

    local _, longest = dkopath.longest_subdir(compact)
    local extrachars = vim
      .iter({
        2 + 5, -- counts
        8, -- icon and root text
        2 + 1, -- branch indicator
        self.branch:len(), -- branch
        2 + 7, -- clipboard indicator
        2 + 1, -- remote indicator
      })
      :fold(0, function(acc, v)
        return acc + v
      end)
    local remaining = self.ui.width
      - extrachars
      - (shortname and shortname:len() or 0)
    while longest > 1 and compact:len() > remaining do
      longest = longest - 1
      -- note tail dir is not shortened
      compact = vim.fn.pathshorten(compact, longest)
    end
    local result = shortname and ("~%s/%s"):format(shortname, compact)
      or compact
    return (" %s"):format(result)
  end,
}
