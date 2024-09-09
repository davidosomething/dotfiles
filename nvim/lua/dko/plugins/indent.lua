local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

--- @type 'hlchunk'|'indentmini'
local provider = "hlchunk"

return {
  -- indent guides
  -- every plugin has issues, leave a bunch of configs here and swapping as
  -- needed

  -- https://github.com/nvimdev/indentmini.nvim
  {
    "nvimdev/indentmini.nvim",
    cond = has_ui,
    enabled = provider == "indentmini",
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
        --char = "█",

        -- only draw the last level of indent lines for the block
        only_current = true,
      })
    end,
  },

  -- https://github.com/shellRaining/hlchunk.nvim
  {
    "shellRaining/hlchunk.nvim",
    cond = has_ui,
    enabled = provider == "hlchunk",
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

      local chunk = require("hlchunk.mods.chunk")
      chunk({
        exclude_filetypes = {
          sh = true,
        },
        notify = false,
      }):enable()
    end,
  },
}
