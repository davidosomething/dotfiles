local utils = require("heirline.utils")

local function hl()
  if require("dko.utils.treesitter").is_highlight_enabled() then
    return {
      bg = utils.get_highlight("dkoStatusKey").bg,
      fg = utils.get_highlight("StatusLine").fg,
    }
  end
  return utils.get_highlight("DiffDelete")
end

return {
  condition = function()
    return vim.bo.filetype ~= ""
  end,

  init = function(self)
    -- for toggleterm this is something like
    -- term://~/.dotfiles/nvim//96469:/bin/zsh;#toggleterm#88888
    self.filepath = vim.api.nvim_buf_get_name(0)

    self.icon, self.icon_color = "", ""
    ---@diagnostic disable-next-line: undefined-field
    self.icon = _G.MiniIcons and _G.MiniIcons.get("file", self.filepath) or ""

    self.filetype_text = require("dko.utils.string").smallcaps(
      vim.bo.filetype,
      { numbers = false }
    )
  end,

  utils.surround({ "█", "█" }, function()
    --- red if no treesitter
    local active = hl().bg
    local inactive = utils.get_highlight("StatusLineNC").bg
    return require("dko.heirline.utils").hl(active, inactive)
  end, {
    {
      condition = function(self)
        return self.icon ~= ""
      end,
      provider = function(self)
        return self.icon
      end,
      hl = function()
        local _, icons = pcall(require, "nvim-web-devicons")
        if icons then
          local _, color = icons.get_icon_color_by_filetype(vim.bo.filetype)
          if color then
            return require("dko.heirline.utils").hl(
              { fg = color, bg = hl().bg },
              "StatusLineNC"
            )
          end
        end
        return ""
      end,
    },
    {
      condition = function(self)
        return self.filetype_text ~= ""
      end,
      provider = function(self)
        return (self.icon ~= "" and " " or "") .. self.filetype_text
      end,
      hl = function()
        return require("dko.heirline.utils").hl(hl(), "StatusLineNC")
      end,
    },
  }),
}
