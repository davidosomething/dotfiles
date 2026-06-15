return {
  provider = function(self)
    local dkopath = require("dko.utils.path")
    local full_cwd = vim.uv.cwd() or ""
    local replaced = dkopath.replace_named_dir(full_cwd)
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
    local compact = dkopath.compact_dir(replaced, {
      padding = extrachars,
      max_width = self.ui.width,
      max_segment_width = 16,
    })
    return (" %s"):format(compact)
  end,
}
