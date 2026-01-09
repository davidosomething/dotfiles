local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---@type LazySpec
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
        require("dko.mappings").bind_markdown(bufnr)
      end,
    },
  },

  -- off until we can have buffer specific conceallevel
  -- https://github.com/OXY2DEV/markview.nvim
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false, -- Recommended
  --   -- ft = "markdown" -- If you decide to lazy-load anyway
  --   dependencies = {
  --     -- You will not need this if you installed the
  --     -- parsers manually
  --     -- Or if the parsers are in your $RUNTIMEPATH
  --     "nvim-treesitter/nvim-treesitter",
  --      "nvim-mini/mini.icons",
  --     "nvim-tree/nvim-web-devicons", -- use mini.icons
  --   },
  --   -- commit = "5488c07", -- links in tables fixed
  --   branch = "dev",
  --   config = function()
  --     local markview = require("markview")
  --     local presets = require("markview.presets")
  --     markview.setup({
  --       -- headings color bg only. no icon no conceal content
  --       headings = presets.headings.simple,
  --       list_items = { enable = false },
  --       tables = { block_decorator = false },
  --     })
  --   end,
  -- },

  -- https://github.com/lukas-reineke/headlines.nvim
  {
    "lukas-reineke/headlines.nvim",
    cond = has_ui,
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    opts = {
      markdown = {
        bullets = {},
      },
    },
  },
}
