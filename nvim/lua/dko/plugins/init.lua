local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local BRACKETED_DISABLED = ""

return {
  -- https://github.com/stevearc/oil.nvim
  {
    "stevearc/oil.nvim",
    dependencies = "echasnovski/mini.icons",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      require("dko.mappings").bind_oil()
    end,
  },

  -- because https://github.com/neovim/neovim/issues/1496
  -- once https://github.com/neovim/neovim/pull/10842 is merged, there will
  -- probably be a better implementation for this
  {
    "lambdalisue/vim-suda",
    cmd = "SudaWrite",
    cond = has_ui,
  },

  {
    "echasnovski/mini.bracketed",
    cond = has_ui,
    version = false,
    opts = {
      buffer = { suffix = BRACKETED_DISABLED }, -- using cybu
      -- comment = { suffix = "c" },
      -- conflict = { suffix = "x" },
      diagnostic = {
        --- something weird about the cursor positioning of this compared to the
        --- built-in ]d [d
        suffix = BRACKETED_DISABLED,
        options = {
          float = require("dko.settings").get("diagnostics.goto_float"),
        },
      },
      -- file = { suffix = "f" },
      indent = { suffix = BRACKETED_DISABLED }, -- confusing
      jump = { suffix = BRACKETED_DISABLED }, -- redundant
      -- location = { suffix = "l" },
      -- oldfile = { suffix = "o" },
      -- quickfix = { suffix = "q" },
      treesitter = { suffix = "n" }, -- n for node, default was t, using it for tab
      undo = { suffix = BRACKETED_DISABLED }, -- I'm using for url
      window = { suffix = BRACKETED_DISABLED }, -- broken going to unlisted
      yank = { suffix = BRACKETED_DISABLED }, -- confusing
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    --- opts will be merged from other specs, e.g. from
    --- ./indent.lua
    --- ./components.lua
    opts = {
      styles = {
        notification = {
          wo = {
            winblend = 0,
          },
        },
      },
      picker = {
        layout = "ivy",
        win = {
          input = {
            keys = vim
              .iter({
                require("dko.mappings.finder").features,
                require("dko.mappings.lsp").features,
              })
              :fold({}, function(acc, features)
                vim.iter(features):each(function(_, config)
                  acc[config.shortcut] = { "close", mode = { "n", "i" } }
                end)
                return acc
              end),
          },
        },
      },
    },
    config = true,
    init = function()
      vim.g.snacks_animate = false
    end,
  },

  -- https://github.com/AndrewRadev/bufferize.vim
  -- `:Bufferize messages` to get messages (or any :command) in a new buffer
  {
    "AndrewRadev/bufferize.vim",
    cmd = "Bufferize",
    config = function()
      vim.g.bufferize_command = "tabnew"
      vim.g.bufferize_keep_buffers = 1
    end,
  },

  -- =========================================================================
  -- ui: diagnostic
  -- =========================================================================

  -- Show diagnostic as virtual text at EOL
  -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   -- event = "VeryLazy",
  --   config = function()
  --     require("tiny-inline-diagnostic").setup({
  --       -- blend = {
  --       --   factor = 0.3,
  --       -- },
  --       -- options = {
  --       --   break_line = {
  --       --     enabled = true,
  --       --     after = 80,
  --       --   },
  --       --   multiple_diag_under_cursor = true,
  --       --   show_source = true,
  --       -- },
  --     })
  --     require("dko.settings").set("diagnostics.goto_float", false)
  --   end,
  -- },

  -- =========================================================================
  -- ui: buffer and window manipulation
  -- =========================================================================

  -- pretty format quickfix and loclist
  {
    "yorickpeterse/nvim-pqf",
    event = { "BufReadPost", "BufNewFile" },
    cond = has_ui,
    config = true,
  },

  -- remove buffers without messing up window layout
  -- https://github.com/echasnovski/mini.bufremove
  {
    "echasnovski/mini.bufremove",
    cond = has_ui,
    config = true,
    version = false, -- dev version
  },

  {
    "ghillb/cybu.nvim",
    cond = has_ui,
    dependencies = {
      "echasnovski/mini.icons",
      -- "nvim-tree/nvim-web-devicons", -- mini icons instead
      "nvim-lua/plenary.nvim",
    },
    keys = vim.tbl_values(require("dko.mappings").cybu),
    config = function()
      require("cybu").setup({
        display_time = 500,
        position = {
          anchor = "centerright",
          max_win_height = 8,
          max_win_width = 0.5,
        },
        style = {
          border = require("dko.settings").get("border"),
          hide_buffer_id = true,
          highlights = {
            background = "dkoBgAlt",
            current_buffer = "dkoQuote",
            adjacent_buffers = "dkoType",
          },
        },
        exclude = { -- filetypes
          "qf",
          "help",
        },
      })
      require("dko.mappings").bind_cybu()
    end,
  },

  -- zoom in/out of a window
  -- this plugin accounts for command window and doesn't use sessions
  -- overrides <C-w>o (originally does an :only)
  {
    "troydm/zoomwintab.vim",
    cond = has_ui,
    keys = require("dko.mappings").zoomwintab,
    cmd = {
      "ZoomWinTabIn",
      "ZoomWinTabOut",
      "ZoomWinTabToggle",
    },
  },

  -- resize window to selection, or split new window with selection size
  {
    "wellle/visual-split.vim",
    cond = has_ui,
    cmd = {
      "VSResize",
      "VSSplit",
      "VSSplitAbove",
      "VSSplitBelow",
    },
  },

  -- <leader>w for picker
  -- https://github.com/yorickpeterse/nvim-window
  {
    "yorickpeterse/nvim-window",
    cond = has_ui,
    keys = vim.tbl_values(require("dko.mappings").nvim_window),
    config = function()
      require("nvim-window").setup({})
      require("dko.mappings").bind_nvim_window()
    end,
  },

  -- remember/restore last cursor position in files
  {
    "ethanholz/nvim-lastplace",
    cond = has_ui,
    config = true,
  },

  -- =========================================================================
  -- ui: terminal
  -- =========================================================================

  {
    "akinsho/toggleterm.nvim",
    keys = require("dko.mappings").toggleterm_all_keys,
    cmd = "ToggleTerm",
    cond = has_ui,
    config = function()
      require("toggleterm").setup({
        float_opts = {
          border = require("dko.settings").get("border"),
        },
        -- built-in mappings only work on LAST USED terminal, so it confuses
        -- the buffer terminal with the floating terminal
        open_mapping = nil,
      })
      require("dko.mappings").bind_toggleterm()
    end,
  },

  -- =========================================================================
  -- Reading
  -- =========================================================================

  -- jump to :line:column in filename:3:20
  --
  -- has indexing errors
  -- https://github.com/lewis6991/fileline.nvim/
  --{ "lewis6991/fileline.nvim" },
  --
  -- https://github.com/wsdjeg/vim-fetch
  {
    "wsdjeg/vim-fetch",
    cond = has_ui,
  },

  -- ]u [u mappings to jump to urls
  -- <A-u> to open link picker
  -- https://github.com/axieax/urlview.nvim
  {
    "axieax/urlview.nvim",
    keys = vim.tbl_values(require("dko.mappings").urlview),
    cmd = "UrlView",
    cond = has_ui,
    config = function()
      require("dko.mappings").bind_urlview()
    end,
  },

  -- https://github.com/vuki656/package-info.nvim
  {
    "vuki656/package-info.nvim",
    cond = has_ui,
    dependencies = "MunifTanjim/nui.nvim",
    event = "BufReadPost package.json",
    config = function()
      require("package-info").setup({
        hide_up_to_date = true,
      })

      local c = require("package-info/utils/constants")
      vim.api.nvim_create_autocmd("User", {
        group = c.AUTOGROUP,
        pattern = c.LOAD_EVENT,
        callback = function()
          -- execute a groupless autocmd so heirline can update
          vim.cmd.doautocmd("User", "DkoPackageInfoStatusUpdate")
        end,
      })
    end,
  },

  -- =========================================================================
  -- Syntax
  -- =========================================================================

  -- highlight matching html/xml tag
  -- % textobject
  {
    "andymass/vim-matchup",
    cond = has_ui,
    -- author recommends against lazy loading
    lazy = false,
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_status_offscreen = 0
      -- see behaviors.lua for treesitter integration
    end,
  },

  -- Better highlighting than treesitter
  { "NoahTheDuke/vim-just" },

  -- https://github.com/brenoprata10/nvim-highlight-colors
  -- see output comparison here https://www.reddit.com/r/neovim/comments/1b5gw12/nvimhighlightcolors_now_supports_virtual_text/kt8gog6/?share_id=aUVLJ5zC3yMKjFuHqumGE
  -- can request and colorize from LSP textDocument/documentColor if available
  {
    "brenoprata10/nvim-highlight-colors",
    cond = has_ui,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ---@usage 'background'|'foreground'|'virtual'
      render = "background",
      -- virtual_symbol_position = 'eow',
      -- virtual_symbol_prefix = ' ',
      -- virtual_symbol_suffix = '',
      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = true,
      enable_var_usage = true,
      exclude_filetypes = {
        "lazy",
      },
    },
  },

  -- {
  --   "catgoose/nvim-colorizer.lua",
  --   cond = has_ui,
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     require("colorizer").setup({
  --       buftypes = {
  --         "*",
  --         unpack(vim.tbl_map(function(v)
  --           return "!" .. v
  --         end, require("dko.utils.buffer").SPECIAL_BUFTYPES)),
  --       },
  --       filetypes = vim.tbl_extend("keep", {
  --         "css",
  --         "html",
  --         "scss",
  --       }, require("dko.utils.jsts").fts),
  --       user_default_options = {
  --         css = true,
  --         tailwind = true,
  --       },
  --     })
  --   end,
  -- },

  -- =========================================================================
  -- Writing
  -- =========================================================================

  -- Override <A-hjkl> to move lines in any mode
  -- NB: Normally in insert mode, <A-hjkl> will exit insert and move cursor.
  -- You can use arrow keys in insert mode, so it's a little redundant.
  {
    "echasnovski/mini.move",
    cond = has_ui,
    config = true,
  },

  -- gcc / <Leader>gbc to comment with treesitter integration
  -- 0.10 has built-in treesitter comments, see :h commenting
  -- BUT it does not properly do jsx/tsx which is provided by
  -- ts_context_commentstring
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    cond = has_ui,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        "JoosepAlviste/nvim-ts-context-commentstring",
        -- No longer needs nvim-treesitter after https://github.com/JoosepAlviste/nvim-ts-context-commentstring/pull/80
        opts = {
          -- Disable for Comment.nvim https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
          enable_autocmd = false,
        },
      },
    },
    config = function()
      require("Comment").setup(
        require("dko.mappings").with_commentnvim_mappings({
          -- add treesitter support, want tsx/jsx in particular
          pre_hook = require(
            "ts_context_commentstring.integrations.comment_nvim"
          ).create_pre_hook(),
        })
      )
    end,
  },

  -- vim-sandwich provides a textobj!
  -- sa/sr/sd operators and ib/ab textobjs
  -- https://github.com/echasnovski/mini.surround -- no textobj
  -- https://github.com/kylechui/nvim-surround -- no textobj
  {
    "machakann/vim-sandwich",
    cond = has_ui,
  },

  -- https://github.com/chrisgrieser/nvim-various-textobj
  {
    "chrisgrieser/nvim-various-textobjs",
    cond = has_ui,
    config = function()
      require("various-textobjs").setup({
        keymaps = {
          useDefaults = false,
        },
        textobjs = {
          indentation = {
            -- `false`: only indentation decreases delimit the text object
            -- `true`: indentation decreases as well as blank lines serve as delimiter
            blanksAreDelimiter = false,
          },
        },
      })
      require("dko.mappings").bind_nvim_various_textobjs()
    end,
  },
}
