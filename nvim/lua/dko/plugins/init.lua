local SIGNS = require("dko.diagnostic-lsp").SIGNS

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
        window = { suffix = "w", options = {} },
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

      vim.keymap.set("n", "<A-\\>", "<Cmd>Notifications<CR>", {
        desc = "Show recent notifications",
      })
    end,
  },

  -- Replace vim.ui.select and vim.ui.input, which are used by things like
  -- vim.lsp.buf.code_action and rename
  -- Alternatively could use nvim-telescope/telescope-ui-select.nvim
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
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

  {
    "davidosomething/everandever.nvim",
    dev = true,
  },

  {
    "rebelot/heirline.nvim",
    dependencies = {
      "davidosomething/everandever.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("heirline").setup({
        statusline = {
          fallthrough = false,
          require("dko.heirline.statusline-help"),
          require("dko.heirline.statusline-special"),
          require("dko.heirline.statusline-default"),
        },
        tabline = {
          require("dko.heirline.searchterm"),
          { provider = "%=", hl = "StatusLine" },
          require("dko.heirline.cwd"),
          require("dko.heirline.git"),
          require("dko.heirline.lazy"),
          require("dko.heirline.remote"),
        },
      })
      local ALWAYS = 2
      vim.o.showtabline = ALWAYS
    end,
  },

  -- =========================================================================
  -- ui: quickfix / loclist modifications
  -- =========================================================================

  -- shrink quickfix to fit
  {
    "blueyed/vim-qf_resize",
    init = function()
      vim.g.qf_resize_min_height = 4
    end,
  },

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

  -- =========================================================================
  -- ui: buffer and window manipulation
  -- =========================================================================

  -- remove buffers without messing up window layout
  {
    "echasnovski/mini.bufremove",
    version = "*",
    keys = {
      {
        "<Leader>x",
        function()
          ---@diagnostic disable-next-line: missing-parameter
          require("mini.bufremove").delete()
        end,
        desc = "Remove buffer without closing window",
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require("mini.bufremove").setup()
    end,
  },

  {
    "ghillb/cybu.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "[b",
        "<Plug>(CybuPrev)",
        desc = "Previous buffer with cybu popup",
      },
      {
        "]b",
        "<Plug>(CybuNext)",
        desc = "Next buffer with cybu popup",
      },
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
    config = function()
      require("nvim-lastplace").setup({})
    end,
  },

  -- =========================================================================
  -- ui: terminal
  -- =========================================================================

  {
    "numtostr/FTerm.nvim",
    keys = {
      {
        "<A-i>",
        function()
          require("FTerm").toggle()
        end,
        desc = "Toggle FTerm",
      },
    },
    config = function()
      require("FTerm").setup({
        border = "rounded",
      })
      vim.keymap.set(
        "t",
        "<A-i>",
        '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>'
      )
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
      local gs = require("gitsigns")
      gs.setup({
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Prev hunk" })

          -- Actions
          -- the ones that use <Cmd> take a range, don't pass as gs.method
          map(
            { "n", "v" },
            "<leader>hr",
            "<Cmd>Gitsigns reset_hunk",
            { desc = "Reset hunk" }
          )
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "gb", function()
            gs.blame_line({ full = true })
          end, { desc = "Show blames" })

          -- Text object
          map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", {
            desc = "Select hunk",
          })
        end,
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
    config = function()
      require("urlview")
      vim.keymap.set("n", "<A-u>", "<Cmd>UrlView<CR>", { desc = "Open URLs" })
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      local function apply_highlights()
        vim.cmd(
          [[highlight IndentBlanklineIndent2 guibg=#242424 gui=nocombine]]
        )
        vim.cmd(
          [[highlight IndentBlanklineContextChar guifg=#664422 gui=nocombine]]
        )
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
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
    end,
  },

  -- Add file manip commands like Remove, Move, Rename, SudoWrite
  -- Do not lazy load, tracks buffers
  { "tpope/vim-eunuch" },

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

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "andymass/vim-matchup",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          -- @TODO until I update vim-colors-meh with treesitter @matches
          enable = require("dko.settings").get("treesitter.highlight_enabled"),
          disable = function(lang, buf)
            if
              vim.tbl_contains({
                -- treesitter language, not ft
                -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
                "javascript", -- and jsx
                "tsx",
              }, lang)
            then
              return true
            end

            -- See behaviors.lua too
            -- Disable for large files
            local max_filesize = 300 * 1024 -- 300 KB
            local ok, stats =
              pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },

        indent = { enable = true },

        -- ===================================================================
        -- 3rd party modules
        -- ===================================================================

        -- 'JoosepAlviste/nvim-ts-context-commentstring',
        context_commentstring = { enable = true, enable_autocmd = false },

        -- 'andymass/vim-matchup',
        matchup = { enable = true },
      })
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        context_commentstring = {
          enable = true, -- Comment.nvim wants this
          enable_autocmd = false, -- Comment.nvim wants this
        },
      })
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
    keys = {
      {
        "gs",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle treesitter split / join",
        silent = true,
      },
    },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 255,
      })
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
      local function textobjMap(obj, char)
        char = char or obj:sub(1, 1)
        vim.keymap.set(
          { "o", "x" },
          "a" .. char,
          "<Plug>(textobj-" .. obj .. "-a)",
          { desc = "textobj: around " .. obj }
        )
        vim.keymap.set(
          { "o", "x" },
          "i" .. char,
          "<Plug>(textobj-" .. obj .. "-i)",
          { desc = "textobj: inside " .. obj }
        )
      end

      textobjMap("indent")
      vim.keymap.set("n", "<Leader>s", "vii:!sort<CR>", {
        desc = "Auto select indent and sort",
        remap = true, -- since ii is a mapping too
      })

      textobjMap("paste", "P")
      textobjMap("url")
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = false })
      -- vim.keymap.set({ "o", "x" }, "ii", function()
      --   require("various-textobjs").indentation(true, true)
      --   vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
      -- end, { desc = "textobj: indent" })
      vim.keymap.set({ "o", "x" }, "ik", function()
        require("various-textobjs").key(true)
      end, { desc = "textobj: key" })
      vim.keymap.set({ "o", "x" }, "iv", function()
        require("various-textobjs").value(true)
      end, { desc = "textobj: value" })
      vim.keymap.set({ "o", "x" }, "is", function()
        require("various-textobjs").subword(true)
      end, { desc = "textobj: camel-_Snake" })
      -- vim.keymap.set({ "o", "x" }, "iu", function()
      --   require("various-textobjs").url()
      -- end, { desc = "textobj: url" })
    end,
  },
}
