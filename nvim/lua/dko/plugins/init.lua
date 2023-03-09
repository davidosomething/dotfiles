local SIGNS = require("dko.diagnostic").SIGNS

return {

  {
    "echasnovski/mini.bracketed",
    version = false,
    config = function()
      require("mini.bracketed").setup({
        buffer = { suffix = "", options = {} }, -- using cybu
        comment = { suffix = "c", options = {} },
        conflict = { suffix = "x", options = {} },
        -- don't want diagnostic float focus, have in mappings.lua
        diagnostic = { suffix = "", options = {} },
        file = { suffix = "f", options = {} },
        indent = { suffix = "", options = {} }, -- confusing
        jump = { suffix = "", options = {} }, -- redundant
        location = { suffix = "l", options = {} },
        oldfile = { suffix = "o", options = {} },
        quickfix = { suffix = "q", options = {} },
        treesitter = { suffix = "t", options = {} },
        undo = { suffix = "", options = {} },
        window = { suffix = "", options = {} }, -- broken going to unlisted
        yank = { suffix = "", options = {} }, -- confusing
      })
    end,
  },

  -- =========================================================================
  -- ui: colorscheme
  -- =========================================================================

  {
    "davidosomething/vim-colors-meh",
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme meh ]])
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        buftypes = {
          "*",
          unpack(vim.tbl_map(function(v)
            return "!" .. v
          end, require("dko.utils.buffer").SPECIAL_BUFTYPES)),
        },
        filetypes = {
          "css",
          "html",
          "javascript",
          "javascriptreact",
          "scss",
          "typescript",
          "typescriptreact",
        },
        css = true,
        tailwind = true,
      })
    end,
  },

  -- =========================================================================
  -- ui: components
  -- =========================================================================

  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require("notify")
      notify.setup({
        max_height = 8,
        max_width = 50,
        minimum_width = 50,
        timeout = 2500,
        stages = vim.go.termguicolors and "fade_in_slide_out" or "slide",
        icons = {
          DEBUG = "",
          ERROR = SIGNS.Error,
          INFO = SIGNS.Info,
          TRACE = "✎",
          WARN = SIGNS.Warn,
        },
      })

      local notifications = require("dko.utils.notifications")
      notifications.override_builtin(notify)
      notifications.override_lsp()

      vim.api.nvim_create_autocmd("User", {
        pattern = "EscEscEnd",
        desc = "Dismiss notifications on <Esc><Esc>",
        callback = function()
          notify.dismiss({ silent = true, pending = true })
        end,
        group = vim.api.nvim_create_augroup("dkonvimnotify", {}),
      })

      require("dko.mappings").bind_notify()
    end,
  },

  -- Replace vim.ui.select and vim.ui.input, which are used by things like
  -- vim.lsp.buf.code_action and rename
  -- Alternatively could use nvim-telescope/telescope-ui-select.nvim
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    -- dependencies = {
    --   "nvim-telescope/telescope.nvim",
    -- },
    config = function()
      require("dressing").setup({
        select = {
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                telescope = require("telescope.themes").get_cursor({
                  prompt_prefix = "🔍 ",
                }),
              }
            end
          end,
        },
      })
    end,
  },

  -- =========================================================================
  -- ui: buffer and window manipulation
  -- =========================================================================

  -- pretty format quickfix and loclist
  {
    "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("pqf").setup({
        signs = {
          error = SIGNS.Error,
          warning = SIGNS.Warn,
          hint = SIGNS.Hint,
          info = SIGNS.Info,
        },
        --show_multiple_lines = false,
      })
    end,
  },

  -- remove buffers without messing up window layout
  {
    "echasnovski/mini.bufremove",
    version = "*",
    keys = "<Leader>x",
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require("mini.bufremove").setup()
      require("dko.mappings").bind_bufremove()
    end,
  },

  {
    "ghillb/cybu.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      "[b",
      "]b",
    },
    config = function()
      require("cybu").setup({
        display_time = 500,
        position = {
          max_win_height = 8,
          max_win_width = 0.8,
        },
        style = {
          border = "rounded",
          hide_buffer_id = true,
          highlights = {
            background = "dkoBgAlt",
            current_buffer = "dkoQuote",
            adjacent_buffers = "dkoType",
          },
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
    keys = {
      "<C-w>o",
      "<C-w><C-o>",
    },
    cmd = {
      "ZoomWinTabIn",
      "ZoomWinTabOut",
      "ZoomWinTabToggle",
    },
  },

  -- resize window to selection, or split new window with selection size
  {
    "wellle/visual-split.vim",
    cmd = {
      "VSResize",
      "VSSplit",
      "VSSplitAbove",
      "VSSplitBelow",
    },
  },

  -- remember/restore last cursor position in files
  {
    "ethanholz/nvim-lastplace",
    config = true,
  },

  -- =========================================================================
  -- ui: terminal
  -- =========================================================================

  {
    "numtostr/FTerm.nvim",
    keys = "<A-i>",
    config = function()
      require("FTerm").setup({ border = "rounded" })
      require("dko.mappings").bind_fterm()
    end,
  },

  -- =========================================================================
  -- ui: diffing
  -- =========================================================================

  -- show diff when editing a COMMIT_EDITMSG
  {
    "rhysd/committia.vim",
    lazy = false, -- just in case
    init = function()
      vim.g.committia_open_only_vim_starting = 0
      vim.g.committia_use_singlecolumn = "always"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = require("dko.mappings").bind_gitsigns,
        preview_config = {
          border = "rounded",
        },
      })
    end,
  },

  -- =========================================================================
  -- Reading
  -- =========================================================================

  -- https://github.com/axieax/urlview.nvim
  {
    "axieax/urlview.nvim",
    keys = "<A-u>",
    config = function()
      require("urlview")
      require("dko.mappings").bind_urlview()
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      local function apply_highlights()
        vim.cmd([[
          highlight IndentBlanklineIndent2 guibg=#242424 gui=nocombine
          highlight IndentBlanklineContextChar guifg=#664422 gui=nocombine
        ]])
      end
      apply_highlights()

      vim.api.nvim_create_autocmd("colorscheme", {
        desc = "Re-apply my indent-blankline highlights",
        callback = apply_highlights,
        group = vim.api.nvim_create_augroup("dkoindentblankline", {}),
      })

      require("indent_blankline").setup({
        filetype_exclude = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },

        -- char = "▏",
        --char = "│",
        -- as bg colors
        char = "",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },

        show_trailing_blankline_indent = false,
        show_current_context = true,
        use_treesitter = true,
      })
    end,
  },

  -- =========================================================================
  -- Editing
  -- =========================================================================

  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({
        highlight = { timer = 300 },
      })
      require("dko.mappings").bind_yanky()
    end,
  },

  -- highlight matching html/xml tag
  -- % textobject
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.matchup_delim_noskips = 2
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_status_offscreen = 0
    end,
  },

  -- <A-hjkl> to move lines in any mode
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
    end,
  },

  -- gcc / <Leader>gbc to comment with treesitter integration
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup({
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap (default gc)
          line = "gc",
          ---Block-comment keymap (gb is my blame command)
          block = "<Leader>gb",
        },
        toggler = {
          ---Line-comment toggle keymap
          line = "gcc",
          ---Block-comment toggle keymap
          block = "<Leader>gbc",
        },
        pre_hook = require(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
      })
    end,
  },

  {
    "Wansmer/treesj",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = "gs",
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 255,
      })
      require("dko.mappings").bind_treesj()
    end,
  },

  -- vim-sandwich provides a textobj!
  -- sa/sr/sd operators and ib/ab textobjs
  -- https://github.com/echasnovski/mini.surround -- no textobj
  -- https://github.com/kylechui/nvim-surround -- no textobj
  {
    "machakann/vim-sandwich",
  },

  -- Still using these over nvim-various-textobjs because they are dot
  -- repeatable.
  -- see https://github.com/chrisgrieser/nvim-various-textobjs/issues/7
  {
    "kana/vim-textobj-user",
    dependencies = {
      "kana/vim-textobj-indent",
      "gilligan/textobj-lastpaste",
      "mattn/vim-textobj-url",
    },
    config = function()
      require("dko.mappings").bind_textobj()
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = false })
      require("dko.mappings").bind_nvim_various_textobjs()
    end,
  },
}
