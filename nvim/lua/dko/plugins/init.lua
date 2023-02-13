return {
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

  -- =========================================================================
  -- ui: components
  -- =========================================================================

  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      vim.notify = require("notify")
      vim.notify.setup({
        max_height = 8,
        max_width = 40,
        timeout = 2500,
        stages = vim.go.termguicolors and "fade_in_slide_out" or "slide",
      })

      -- Show LSP messages via vim.notify (but only when using nvim-notify)
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
        vim.notify(result.message, lvl, {
          title = "LSP | " .. client.name,
          timeout = 10000,
          keep = function()
            return lvl == "ERROR" or lvl == "WARN"
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "EscEscEnd",
        desc = "Dismiss notifications on <Esc><Esc>",
        callback = function()
          vim.notify.dismiss({ silent = true, pending = true })
        end,
        group = vim.api.nvim_create_augroup("dkonvimnotify", { clear = true }),
      })

      vim.keymap.set("n", "<A-\\>", "<Cmd>Notifications<CR>", {
        desc = "Show recent notifications",
      })
    end,
  },

  -- Replace vim.ui.select and vim.ui.input, which are used by things like
  -- vim.lsp.buf.code_action and rename
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        select = {
          backend = { "builtin" },
        },
      })
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
      local SIGNS = require("dko.diagnostic-lsp").SIGNS
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
  -- ui: editing helpers
  -- =========================================================================

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      require("indent_blankline").setup({
        -- char = "▏",
        char = "│",
        filetype_exclude = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
        show_trailing_blankline_indent = false,
        show_current_context = false,
        use_treesitter = true,
      })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        buftypes = {
          "*",
          "!nofile", -- ignore nofile, e.g. :Mason buffer
        },
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
      "rcarriga/nvim-notify",
      "Wansmer/treesj",
    },
    build = ":TSUpdate",
    config = function()
      local highlight_enabled = false

      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          -- @TODO until I update vim-colors-meh with treesitter @matches
          enable = highlight_enabled,
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

      vim.keymap.set("n", "ss", function()
        if not highlight_enabled then
          vim.notify("Treesitter highlight is disabled", "error")
          return
        end

        vim.pretty_print(vim.treesitter.get_captures_at_cursor())
      end, { desc = "Copy treesitter captures under cursor" })

      vim.keymap.set("n", "sy", function()
        if not highlight_enabled then
          vim.notify("Treesitter highlight is disabled", "error")
          return
        end

        local captures = vim.treesitter.get_captures_at_cursor()
        local parsedCaptures = {}
        for _, capture in ipairs(captures) do
          table.insert(parsedCaptures, "@" .. capture)
        end
        if #parsedCaptures == 0 then
          vim.notify(
            "No treesitter captures under cursor",
            "error",
            { title = "Yank failed" }
          )
          return
        end
        local resultString = vim.inspect(parsedCaptures)
        vim.fn.setreg("+", resultString .. "\n")
        vim.notify(resultString, "info", { title = "Yanked capture" })
      end, { desc = "Copy treesitter captures under cursor" })
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
    keys = {
      {
        "gs",
        "<Cmd>TSJToggle<CR>",
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

  -- =========================================================================
  -- Editing: textobj
  -- =========================================================================

  -- vim-sandwich provides a textobj!
  -- sa/sr/sd operators and ib/ab textobjs
  -- https://github.com/echasnovski/mini.surround -- no textobj
  -- https://github.com/kylechui/nvim-surround -- no textobj
  {
    "machakann/vim-sandwich",
  },

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
        vim.keymap.set("o", "a" .. char, "<Plug>(textobj-" .. obj .. "-a)", {
          desc = "Operator - around " .. obj,
        })
        vim.keymap.set("x", "a" .. char, "<Plug>(textobj-" .. obj .. "-a)", {
          desc = "Visual - around " .. obj,
        })
        vim.keymap.set("o", "i" .. char, "<Plug>(textobj-" .. obj .. "-i)", {
          desc = "Operator - inside " .. obj,
        })
        vim.keymap.set("x", "i" .. char, "<Plug>(textobj-" .. obj .. "-i)", {
          desc = "Visual - inside " .. obj,
        })
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

  -- =========================================================================
  -- Language: Starlark
  -- E.g. Caddy 2 configs, Tilt, Drone, Bazel
  -- No treesitter grammar yet
  -- =========================================================================

  { "cappyzawa/starlark.vim" },
}
