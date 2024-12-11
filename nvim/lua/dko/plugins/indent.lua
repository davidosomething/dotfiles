--- Plugins to show indent and chunk guides
--- They all have issues, leave a bunch of configs here and swapping as needed

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

--- Provider to show indent levels
--- @type ''|'hlchunk'|'indentmini'|'snacks'
local indent = ""
local indent_char = "█"

--- Provider to show current chunk
--- As of 2024-12-11, indentmini is still much faster than the rest and no
--- stupid animations.
--- @type ''|'hlchunk'|'indentmini'|'snacks'
local chunk = "indentmini"
local chunk_char = "│"

return {
  {
    "folke/snacks.nvim",
    --- merged
    opts = {
      indent = {
        enabled = indent == "snacks" or chunk == "snacks",
        char = indent_char,
        only_current = true,
        --- Only the current scope, not all indents
        only_scope = indent ~= "snacks",
      },
      scope = {
        enabled = true,
        animate = {
          enabled = false,
          duration = {
            step = 1,
            total = 1,
          },
        },
      },
      chunk = {
        enabled = chunk == "snacks",
        only_current = true,
      },
    },
  },

  -- https://github.com/nvimdev/indentmini.nvim
  {
    "nvimdev/indentmini.nvim",
    cond = has_ui,
    enabled = chunk == "indentmini" or indent == "indentmini",
    event = "BufEnter",
    config = function()
      local function color()
        vim.cmd.highlight("IndentLine guifg=bg")
        -- vim.cmd.highlight(
        --   ("IndentLine guifg=%s"):format(
        --     require("dko.colors").is_dark() and "#242426" or "#f4f2ef"
        --   )
        -- )
        vim.cmd.highlight(
          ("IndentLineCurrent guifg=%s"):format(
            require("dko.colors").is_dark() and "#344466" or "#c4c2df"
          )
        )
      end
      vim.api.nvim_create_autocmd("colorscheme", {
        callback = color,
        desc = "change indent guide colors with colorscheme",
      })
      color()

      require("indentmini").setup({
        char = chunk_char,
        -- only draw the last level of indent lines for the block
        only_current = indent ~= "indentmini",
      })
    end,
  },

  -- https://github.com/shellRaining/hlchunk.nvim
  {
    "shellRaining/hlchunk.nvim",
    cond = has_ui,
    enabled = chunk == "hlchunk",
    event = "UIEnter",
    config = function()
      -- local exclude_filetype = {
      --   "help",
      --   "plugin",
      --   "alpha",
      --   "dashboard",
      --   "neo-tree",
      --   "Trouble",
      --   "lazy",
      --   "mason",
      -- }

      -- local blank = require("hlchunk.mods.indent")
      -- blank({
      --   enable = hlchunk_blank,
      --   exclude_filetype = exclude_filetype,
      --   chars = { " " },
      --   notify = false,
      --   style = {
      --     { bg = "", fg = "" },
      --     {
      --       bg = function()
      --         return require("dko.colors").is_dark() and "#242426" or "#f4f2ef"
      --       end,
      --     },
      --   },
      -- }):enable()

      local chunk_mod = require("hlchunk.mods.chunk")
      chunk_mod({
        delay = 150,
        duration = 150,
        exclude_filetypes = {
          sh = true,
        },
        notify = false,
      }):enable()
    end,
  },
}
