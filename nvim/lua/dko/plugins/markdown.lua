local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- https://github.com/tadmccorkle/markdown.nvim
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      mappings = {
        inline_surround_toggle = false,
        inline_surround_toggle_line = false,
        inline_surround_delete = false,
        inline_surround_change = false,
        link_add = "gl", -- (string|boolean) add link
        link_follow = false, -- (string|boolean) follow link
        go_curr_heading = false,
        go_parent_heading = false,
        go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
        go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
      },
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map("n", "<c-x>", "<Cmd>MDTaskToggle<CR>", opts)
      end,
    },
  },

  -- off until fix https://github.com/OXY2DEV/markview.nvim/issues/75
  -- https://github.com/OXY2DEV/markview.nvim
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    -- commit = "5488c07", -- links in tables fixed
    branch = "dev",
    config = function()
      local markview = require("markview")
      local presets = require("markview.presets")
      markview.setup({
        -- headings color bg only, no icon no conceal content
        headings = presets.headings.simple,
        -- tables = { enable = false },
        tables = { block_decorator = false },
      })
    end,
  },

  -- {
  --   "lukas-reineke/headlines.nvim",
  --   cond = has_ui,
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     markdown = {
  --       bullets = {},
  --     },
  --   }, -- or `opts = {}`
  -- },
}
