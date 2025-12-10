local hidden_filetypes = require("dko.utils.table").concat({
  "markdown",
}, require("dko.utils.jsts").fts)

return {
  init = function(self)
    -- for toggleterm this is something like
    -- term://~/.dotfiles/nvim//96469:/bin/zsh;#toggleterm#88888
    self.filepath = vim.api.nvim_buf_get_name(0)

    self.icon, self.icon_color = "", ""
    ---@diagnostic disable-next-line: undefined-field
    self.icon = _G.MiniIcons and _G.MiniIcons.get("file", self.filepath) or ""

    self.filetype_text = vim.list_contains(hidden_filetypes, vim.bo.filetype)
        and ""
      or require("dko.utils.string").smallcaps(
        vim.bo.filetype,
        { numbers = false }
      )
  end,
  hl = function()
    return require("dko.heirline.utils").hl()
  end,
  require("dko.heirline.winbar-filetype"),
  require("dko.heirline.winbar-filename"),
  require("dko.heirline.winbar-filepath"),
  require("dko.heirline.winbar-terminal"),
  { provider = "%=" },
  require("dko.heirline.lightbulb"),
  require("dko.heirline.winbar-formatters"),
  require("dko.heirline.winbar-diagnostics"),
}
