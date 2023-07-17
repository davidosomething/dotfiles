--- @type 'hlchunk'|'indentmini'
local enabled = "hlchunk"

local hlchunk_blank = false
local hlchunk_chunk = true
local hlchunk_indent = false

return {
  -- indent guides
  -- every plugin has issues, leave a bunch of configs here and swapping as
  -- needed

  -- =========================================================================
  -- https://github.com/nvimdev/indentmini.nvim
  -- =========================================================================
  {
    "nvimdev/indentmini.nvim",
    enabled = enabled == "indentmini",
    event = "BufEnter",
    config = function()
      require("indentmini").setup({
        char = "█",
      })
      local function color()
        vim.cmd.highlight(
          ("default IndentLine guifg=%s"):format(
            require("dko.colors").is_dark() and "#242426" or "#f4f2ef"
          )
        )
      end
      vim.api.nvim_create_autocmd("colorscheme", {
        callback = color,
        desc = "change indent guide colors with colorscheme",
      })
      color()
    end,
  },

  -- =========================================================================
  -- https://github.com/shellRaining/hlchunk.nvim
  -- =========================================================================

  {
    "shellRaining/hlchunk.nvim",
    enabled = enabled == "hlchunk",
    event = "UIEnter",
    config = function()
      local exclude_filetype = {
        "help",
        "plugin",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
      }

      require("hlchunk").setup({
        blank = {
          enable = hlchunk_blank,
          exclude_filetype = exclude_filetype,
          chars = { " " },
          notify = false,
          style = {
            { bg = "", fg = "" },
            {
              bg = function()
                return require("dko.colors").is_dark() and "#242426"
                  or "#f4f2ef"
              end,
            },
          },
        },
        chunk = {
          enable = hlchunk_chunk,
          exclude_filetypes = {
            sh = true,
          },
          notify = false,
        },
        indent = { enable = hlchunk_indent },
        line_num = { enable = false },
      })
    end,
  },
}
