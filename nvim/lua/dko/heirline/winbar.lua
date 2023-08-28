local icon_color_enabled = false

local function active_highlight(active)
  active = active or "StatusLine"
  return require("heirline.conditions").is_active() and active or "StatusLineNC"
end

return {
  {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)

      self.filetype_text = vim.list_contains(
        { "javascript", "markdown" },
        vim.bo.filetype
      ) and "" or " " .. require("dko.utils.string").smallcaps(
        vim.bo.filetype
      )
    end,
    hl = function()
      return active_highlight()
    end,

    {
      condition = function()
        return vim.bo.filetype ~= ""
      end,

      -- =======================================================================
      -- treesitter highlight status
      -- =======================================================================

      {
        provider = function()
          if
            require("heirline.conditions").buffer_matches({
              buftype = require("dko.utils.buffer").SPECIAL_BUFTYPES,
              filetype = require("dko.utils.buffer").SPECIAL_FILETYPES,
            })
          then
            return ""
          end
          return "  "
        end,
        hl = function()
          return active_highlight(
            require("dko.treesitter").is_highlight_enabled() and "DiffAdd"
              or "DiffDelete"
          )
        end,
      },

      -- =======================================================================
      -- filetype icon and text
      -- =======================================================================

      {
        init = function(self)
          if vim.bo.buftype ~= "" then
            self.icon = ""
            self.icon_color = ""
          else
            local extension = vim.fn.fnamemodify(self.filename, ":e")
            local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
            if ok then
              self.icon, self.icon_color = nvim_web_devicons.get_icon_color(
                self.filename,
                extension,
                { default = true }
              )
            end
          end
        end,
        provider = function(self)
          -- Don't bother outputting these, the nerd icon is sufficient
          return self.icon ~= ""
              and (" %s%s "):format(self.icon, self.filetype_text)
            or self.filetype_text .. " "
        end,
        hl = function(self)
          if icon_color_enabled and self.icon_color then
            return { fg = self.icon_color }
          end
          return active_highlight("dkoStatusKey")
        end,
      },
    },

    -- =========================================================================
    -- terminal help
    -- =========================================================================

    {
      condition = function()
        return vim.bo.buftype == "terminal"
      end,
      provider = function()
        return " [<A-i> hide] [<A-x> mode] "
      end,
      hl = function()
        return active_highlight()
      end,
    },

    -- =========================================================================
    -- file path and readonly indicator
    -- =========================================================================

    {
      condition = function()
        return vim.bo.buftype == "" or vim.bo.buftype == "help"
      end,

      {
        provider = function(self)
          if self.filename == "" then
            return " ᴜɴɴᴀᴍᴇᴅ "
          end

          local win_width = vim.api.nvim_win_get_width(0)
          local extrachars = 3 + 3 + self.filetype_text:len() + 16
          local remaining = win_width - extrachars

          local final
          local relative = vim.fn.fnamemodify(self.filename, ":~:.") or ""
          if relative:len() < remaining then
            final = relative
          else
            local shorten = require("dko.utils.path").shorten
            local len = 8
            while len > 0 and type(final) ~= "string" do
              local attempt = shorten(self.filename, len)
              final = attempt:len() < remaining and attempt
              len = len - 2
            end
            if not final then
              final = shorten(self.filename, 1)
            end
          end
          return " %<" .. final .. " "
        end,
        hl = function()
          return vim.bo.modified and "Todo" or active_highlight("StatusLine")
        end,
      },

      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "  ",
        hl = "dkoLineImportant",
      },
    },
  },

  -- spacer with active bg color
  {
    provider = "%=",
    hl = function()
      return active_highlight()
    end,
  },

  {
    condition = function()
      return vim.bo.buftype == "" -- normal
    end,
    require("dko.heirline.package-info"),
    require("dko.heirline.lsp"),
    require("dko.heirline.diagnostics"),
  },
}
