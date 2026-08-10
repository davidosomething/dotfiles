return {
  provider = function(self)
    local dkopath = require("dko.utils.path")
    -- the remote indicator gets wider when it shows a wezterm tab id
    local remote_tab_id = require("dko.heirline.utils").remote_tab_id()
    local full_cwd = vim.uv.cwd() or ""
    local replaced = dkopath.replace_named_dir(full_cwd)
    local extrachars = vim
      .iter({
        2 + 5, -- counts
        8, -- icon and root text
        2 + 1, -- branch indicator
        self.branch:len(), -- branch
        2 + 7, -- clipboard indicator
        2 + 1 + (remote_tab_id and #remote_tab_id + 1 or 0), -- remote indicator
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
