local dkosettings = require("dko.settings")
local dkomappings = require("dko.mappings")
local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  {
    "echasnovski/mini.bracketed",
    version = false,
    config = function()
      require("mini.bracketed").setup({
        buffer = { suffix = "", options = {} }, -- using cybu
        comment = { suffix = "c", options = {} },
        conflict = { suffix = "x", options = {} },
        -- don't want diagnostic float focus, have in mappings.lua with coc
        -- support too
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

  {
    "folke/snacks.nvim",
    config = function()
      vim.api.nvim_create_user_command("Gitbrowse", function()
        local gbok, gb = pcall(require, "snacks.gitbrowse")
        if not gbok then
          return
        end
        gb.open()
      end, { desc = "Open branch, file, line in origin git site" })

      vim.api.nvim_create_user_command("Gitbranch", function()
        local gbok, gb = pcall(require, "snacks.gitbrowse")
        if not gbok then
          return
        end
        gb.open({ what = "branch" })
      end, { desc = "Open branch in origin git site" })

      vim.api.nvim_create_user_command("Gitrepo", function()
        local gbok, gb = pcall(require, "snacks.gitbrowse")
        if not gbok then
          return
        end
        gb.open({ what = "repo" })
      end, { desc = "Open repo root in origin git site" })
    end,
  },

  -- =========================================================================
  -- ui: components
  -- =========================================================================

  -- use mini.icons instead
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   lazy = true,
  --   cond = has_ui,
  --   config = true,
  -- },
  {
    "echasnovski/mini.icons",
    lazy = true,
    cond = has_ui,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- Replace vim.ui.select and vim.ui.input, which are used by things like
  -- vim.lsp.buf.code_action and rename
  -- Alternatively could use https://github.com/nvim-telescope/telescope-ui-select.nvim
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    cond = has_ui,
    event = "VeryLazy",
  },

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
  --     dkosettings.set("diagnostics.goto_float", false)
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
    config = function()
      require("pqf").setup()
    end,
  },

  -- remove buffers without messing up window layout
  -- https://github.com/echasnovski/mini.bufremove
  {
    "echasnovski/mini.bufremove",
    version = false, -- dev version
    config = function()
      require("mini.bufremove").setup()
    end,
  },

  {
    "ghillb/cybu.nvim",
    cond = has_ui,
    dependencies = {
      "echasnovski/mini.icons",
      -- "nvim-tree/nvim-web-devicons", -- mini icons instead
      "nvim-lua/plenary.nvim",
    },
    keys = vim.tbl_values(dkomappings.cybu),
    config = function()
      require("cybu").setup({
        display_time = 500,
        position = {
          anchor = "centerright",
          max_win_height = 8,
          max_win_width = 0.5,
        },
        style = {
          border = dkosettings.get("border"),
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
      dkomappings.bind_cybu()
    end,
  },

  -- zoom in/out of a window
  -- this plugin accounts for command window and doesn't use sessions
  -- overrides <C-w>o (originally does an :only)
  {
    "troydm/zoomwintab.vim",
    cond = has_ui,
    keys = dkomappings.zoomwintab,
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
    keys = vim.tbl_values(dkomappings.nvim_window),
    config = function()
      require("nvim-window").setup({})
      dkomappings.bind_nvim_window()
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
    keys = dkomappings.toggleterm_all_keys,
    cmd = "ToggleTerm",
    cond = has_ui,
    config = function()
      require("toggleterm").setup({
        float_opts = {
          border = dkosettings.get("border"),
        },
        -- built-in mappings only work on LAST USED terminal, so it confuses
        -- the buffer terminal with the floating terminal
        open_mapping = nil,
      })
      dkomappings.bind_toggleterm()
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
    cond = has_ui,
    config = function()
      require("gitsigns").setup({
        on_attach = dkomappings.bind_gitsigns,
        preview_config = {
          border = dkosettings.get("border"),
        },
      })
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
    keys = vim.tbl_values(dkomappings.urlview),
    cmd = "UrlView",
    cond = has_ui,
    config = function()
      dkomappings.bind_urlview()
    end,
  },

  -- https://github.com/vuki656/package-info.nvim
  {
    "vuki656/package-info.nvim",
    cond = has_ui,
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufReadPost package.json" },
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

  -- Works better than https://github.com/IndianBoy42/tree-sitter-just
  {
    "NoahTheDuke/vim-just",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "\\cjustfile", "*.just", ".justfile" },
  },

  -- https://github.com/brenoprata10/nvim-highlight-colors
  -- see output comparison here https://www.reddit.com/r/neovim/comments/1b5gw12/nvimhighlightcolors_now_supports_virtual_text/kt8gog6/?share_id=aUVLJ5zC3yMKjFuHqumGE
  {
    "brenoprata10/nvim-highlight-colors",
    cond = has_ui,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-highlight-colors").setup({
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
      })
    end,
  },

  -- {
  --   "NvChad/nvim-colorizer.lua",
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

  -- reconcile filename when using sudoedit
  -- https://github.com/HE7086/sudoedit.nvim
  {
    "HE7086/sudoedit.nvim",
    enabled = function()
      return vim.fn.has("linux") == 1
    end,
  },

  -- because https://github.com/neovim/neovim/issues/1496
  -- once https://github.com/neovim/neovim/pull/10842 is merged, there will
  -- probably be a better implementation for this
  {
    "lambdalisue/suda.vim",
    cond = has_ui,
    cmd = "SudaWrite",
  },

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

  -- Override <A-hjkl> to move lines in any mode
  -- NB: Normally in insert mode, <A-hjkl> will exit insert and move cursor.
  -- You can use arrow keys in insert mode, so it's a little redundant.
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
    end,
  },

  -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- No longer needs nvim-treesitter after https://github.com/JoosepAlviste/nvim-ts-context-commentstring/pull/80
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ts_context_commentstring").setup({
        -- Disable for Comment.nvim https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
        enable_autocmd = false,
      })
    end,
  },

  -- gcc / <Leader>gbc to comment with treesitter integration
  -- 0.10 has built-in treesitter comments, see :h commenting
  -- BUT it does not properly do jsx/tsx which is provided by
  -- ts_context_commentstring
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    cond = has_ui,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, tscc_integration =
        pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if not ok then
        vim.notify(
          "Comment.nvim could not find nvim-ts-context-commentstring",
          vim.log.levels.ERROR
        )
        return
      end
      require("Comment").setup(dkomappings.with_commentnvim_mappings({
        -- add treesitter support, want tsx/jsx in particular
        pre_hook = tscc_integration.create_pre_hook(),
      }))
    end,
  },

  {
    "Wansmer/treesj",
    cond = has_ui,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = dkomappings.trees,
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 255,
      })
      dkomappings.bind_treesj()
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

  {
    "kana/vim-textobj-user",
    cond = has_ui,
    dependencies = {
      "gilligan/textobj-lastpaste",
      "mattn/vim-textobj-url",
    },
    config = function()
      dkomappings.bind_textobj()
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    cond = has_ui,
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = false })
      dkomappings.bind_nvim_various_textobjs()
    end,
  },
}
