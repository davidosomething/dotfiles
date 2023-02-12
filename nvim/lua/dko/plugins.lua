local function hasProject(path)
  return vim.fn.isdirectory(vim.fn.expand(path)) == 1
end

return {
  -- =========================================================================
  -- nvim dev
  -- =========================================================================

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- `:Bufferize messages` to get messages (or any :command) in a new buffer
  {
    "AndrewRadev/bufferize.vim",
    cmd = "Bufferize",
    init = function()
      vim.g.bufferize_command = "tabnew"
    end,
    config = function()
      vim.api.nvim_create_user_command("Bmessages", "Bufferize messages", {
        desc = "Open messages in new buffer",
      })
    end,
  },

  -- @TODO nvim 0.9 has :Inspect ?
  {
    "cocopon/colorswatch.vim",
    dependencies = {
      "cocopon/inspecthi.vim",
    },
    lazy = true,
  },
  {
    "cocopon/inspecthi.vim",
    cmd = "Inspecthi",
    keys = {
      {
        "zs",
        "<Cmd>Inspecthi<CR>",
        desc = "Show highlight groups under cursor",
        silent = true,
      },
    },
  },

  -- =========================================================================
  -- fixes
  -- =========================================================================

  -- Fix CursorHold
  -- https://github.com/neovim/neovim/issues/12587
  {
    "antoinemadec/FixCursorHold.nvim",
    enabled = vim.fn.has("nvim-0.8") == 0,
  },

  -- Disable cursorline when moving, for various perf reasons
  {
    "yamatsum/nvim-cursorline", -- replaces delphinus/auto-cursorline.nvim",
    config = function()
      require("nvim-cursorline").setup({
        cursorline = {
          enable = true,
          timeout = 300,
          number = false,
        },
        cursorword = {
          enable = false, -- https://github.com/yamatsum/nvim-cursorline/issues/27
          min_length = 3,
          hl = { underline = true },
        },
      })
    end,
  },

  -- =========================================================================
  -- polyfills
  -- =========================================================================

  -- apply editorconfig settings to buffer
  -- @TODO follow https://github.com/neovim/neovim/issues/21648
  {
    "gpanders/editorconfig.nvim",
    enabled = vim.fn.has("nvim-0.9") == 0,
  },

  -- prevent new windows from shifting cursor position
  {
    "luukvbaal/stabilize.nvim",
    enabled = vim.fn.exists("+splitkeep") == 0,
    config = function()
      require("stabilize").setup()
    end,
  },

  -- =========================================================================
  -- mine
  -- =========================================================================

  -- HR with <Leader>f[CHAR]
  {
    dir = vim.fn.stdpath("config") .. "/mine/vim-hr",
    config = function()
      local map = vim.fn["hr#map"]
      map("_")
      map("-")
      map("=")
      map("#")
      map("*")
    end,
  },

  -- <Leader>C <Plug>(dkosmallcaps)
  {
    dir = vim.fn.stdpath("config") .. "/mine/vim-smallcaps",
    config = function()
      vim.keymap.set("v", "<Leader>C", "<Plug>(dkosmallcaps)", {
        desc = "Apply vim-smallcaps to visual selection",
      })
    end,
  },

  -- Toggle movement mode line-wise/display-wise
  {
    dir = vim.fn.stdpath("config") .. "/mine/vim-movemode",
    lazy = false, -- I use the autoload fns
    config = function()
      vim.keymap.set("n", "<Leader>mm", "<Cmd>call movemode#toggle()<CR>", {
        desc = "Toggle move mode",
      })
    end,
  },

  -- =========================================================================
  -- ui: colorscheme
  -- =========================================================================

  {
    "davidosomething/vim-colors-meh",
    dev = hasProject("$HOME/projects/vim-colors-meh"),
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
    event = "BufReadPost",
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
        position = {
          max_win_height = 8,
          max_win_width = 0.8,
        },
        style = {
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
    event = "BufReadPost",
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
  -- ui: fzf
  -- =========================================================================

  -- Use the repo instead of the version in brew since it includes the help
  -- docs for fzf#run()
  {
    "junegunn/fzf",
    enabled = vim.fn.exists("&autochdir") == 1,
    dependencies = {
      "junegunn/fzf.vim",
    },
  },
  {
    "junegunn/fzf.vim",
    init = function()
      vim.g.fzf_command_prefix = "FZF"
      vim.g.fzf_layout = { down = "~40%" }
      vim.g.fzf_buffers_jump = 1
    end,
    config = function()
      vim.keymap.set("n", "<A-b>", "<Cmd>FZFBuffers<CR>")
      vim.keymap.set("n", "<A-c>", "<Cmd>FZFCommands<CR>")
      vim.keymap.set("n", "<A-f>", "<Cmd>FZFFiles<CR>")
      vim.keymap.set("n", "<A-g>", "<Cmd>FZFGrepper<CR>")
      vim.keymap.set("n", "<A-m>", "<Cmd>FZFMRU<CR>")
      vim.keymap.set("n", "<A-p>", "<Cmd>FZFProject<CR>")
      vim.keymap.set("n", "<A-r>", "<Cmd>FZFRelevant<CR>")
      vim.keymap.set("n", "<A-s>", "<Cmd>FZFGitStatusFiles<CR>")
      vim.keymap.set("n", "<A-t>", "<Cmd>FZFTests<CR>")
      vim.keymap.set("n", "<A-v>", "<Cmd>FZFVim<CR>")
    end,
  },

  -- =========================================================================
  -- ui: editing helpers
  -- =========================================================================

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
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
    event = "BufReadPost",
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
    event = "BufReadPost",
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
    event = "BufReadPost",
    dependencies = {
      "andymass/vim-matchup",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "Wansmer/treesj",
    },
    build = ":TSUpdate",
    config = function()
      local highlight_enabled = false

      require("nvim-treesitter.configs").setup({
        -- ===================================================================
        -- 3rd party
        -- ===================================================================

        -- 'JoosepAlviste/nvim-ts-context-commentstring',
        context_commentstring = { enable = true, enable_autocmd = false },
        -- 'andymass/vim-matchup',
        matchup = { enable = true },

        -- ===================================================================
        -- Built-in
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
        ensure_installed = "all",
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
    event = "BufReadPost",
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
    event = "BufReadPost",
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
  -- LSP
  -- Scaffold dependencies like LazyVim
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
  -- =========================================================================

  {
    "davidosomething/lsp-progress.nvim",
    dev = hasProject("$HOME/projects/lsp-progress.nvim"),
    branch = "support-table-return",
    event = "BufReadPost",
    dependencies = {
      "vim-smallcaps",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      ---@return table|nil
      local function series_format(title, message, percentage, done)
        if done then
          return nil
        end
        return {
          title = title,
          message = message,
          percentage = percentage,
          done = done,
        }
      end

      ---@class ClientMessage
      ---@field spinner string
      ---@field client_name string
      ---@field title string
      ---@field message string
      ---@field percentage number

      ---@param client_name string
      ---@param spinner string
      ---@param series_messages table
      ---@return ClientMessage|nil passed to format as item in client_messages[]
      local function client_format(client_name, spinner, series_messages)
        series_messages = vim.tbl_filter(function(t)
          return t ~= nil
        end, series_messages)
        if #series_messages > 0 then
          return {
            spinner = spinner,
            client_name = client_name,
            title = series_messages[1].title,
            message = series_messages[1].message,
            percentage = series_messages[1].percentage,
          }
        end
        return nil
      end

      ---@param client_messages ClientMessage[]
      ---@return string that is output when calling .progress()
      local function format(client_messages)
        client_messages = vim.tbl_filter(function(t)
          return t ~= nil
        end, client_messages)
        if #client_messages == 0 then
          return ""
        end

        local clients = {}
        for _, client_message in ipairs(client_messages) do
          table.insert(clients, client_message.client_name)
        end
        local joinedClients = table.concat(clients, ", ")
        local clientsString = vim.fn["smallcaps#convert"](joinedClients)

        -- multi clients, show indeterminate spinner, space, busy client names
        if #client_messages > 1 then
          local spinner = client_messages[1].spinner
          return spinner .. " " .. clientsString
        end

        -- one client, show percentage of current series
        local percentage = client_messages[1].percentage
        local progressUtil = require("dko.utils.progress")
        local percentageBar =
          progressUtil.character(progressUtil.VERTICAL, percentage)

        return percentageBar .. " " .. clientsString
      end

      require("lsp-progress").setup({
        series_format = series_format,
        client_format = client_format,
        format = format,
        spinner = { "◢", "◣", "◤", "◥" },
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        border = "rounded",
        sources = {
          -- provide the typescript.nvim commands as LSP actions
          require("typescript.extensions.null-ls.code-actions"),

          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.shellcheck,

          -- =================================================================
          -- Diagnostics
          -- =================================================================

          -- Switch ALL diagnostics to DIAGNOSTICS_ON_SAVE only
          -- or null_ls will keep spamming LSP events

          null_ls.builtins.diagnostics.editorconfig_checker.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),

          --[[ null_ls.builtins.diagnostics.luacheck.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }), ]]

          null_ls.builtins.diagnostics.markdownlint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),

          null_ls.builtins.diagnostics.qmllint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),

          -- selene not picking up config
          --[[ null_ls.builtins.diagnostics.selene.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            extra_args = function(params)
              local results = vim.fs.find({ 'selene.toml' }, {
                upward = true,
                path = vim.api.nvim_buf_get_name(0)
              })
              if #results == 0 then
                return params
              end
              vim.notify('Found selene.toml at ' .. results[1])
              return { "--config", results[1] }
            end
          }), ]]

          null_ls.builtins.diagnostics.shellcheck.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),

          -- =================================================================
          -- Formatting
          -- =================================================================

          null_ls.builtins.formatting.stylua.with({
            condition = function(utils)
              return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
            end,
          }),
          null_ls.builtins.formatting.markdownlint,
          null_ls.builtins.formatting.qmlformat,
          null_ls.builtins.formatting.shfmt,
        },

        -- defaults to false, but lets just sync it in case I want to change
        -- in my diagnostic-lsp.lua
        update_in_insert = vim.diagnostic.config().update_in_insert,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",

    -- @TODO https://github.com/williamboman/mason-lspconfig.nvim/issues/147
    commit = "ee00aa22dc5254432ac4704e6761d2b127e14622",

    event = "BufReadPre",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "williamboman/mason.nvim",
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local extras = {
        "editorconfig-checker",
        "markdownlint",
      }
      -- Auto-install some linters for null-ls
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L157-L163

      local mr = require("mason-registry")
      for _, tool in ipairs(extras) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
      "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
      "jose-elias-alvarez/typescript.nvim",
      "neovim/nvim-lspconfig", -- wait for lspconfig, which waits for neodev
    },
    config = function()
      -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      local lsps = {
        "ansiblels",
        "bashls",
        "cssls",
        "cssmodules_ls",
        "dockerls",
        "eslint",
        "html",
        "jsonls",
        "stylelint_lsp",
        "sumneko_lua",
        "tailwindcss",
        "tsserver",
        "vimls",
        "yamlls",
      }
      if vim.fn.executable("go") == 1 then
        table.insert(lsps, "gopls")
      end

      local masonLspConfig = require("mason-lspconfig")
      masonLspConfig.setup({
        ensure_installed = lsps,
        automatic_installation = true,
      })

      local cmpNvimLsp = require("cmp_nvim_lsp")

      local defaultOptions = {
        capabilities = cmpNvimLsp.default_capabilities(),
      }

      local lspconfig = require("lspconfig")

      -- Note that instead of on_attach for each server setup,
      -- diagnostic-lsp.lua has an autocmd defined
      masonLspConfig.setup_handlers({
        function(server)
          lspconfig[server].setup(defaultOptions)
        end,

        ["jsonls"] = function()
          lspconfig.jsonls.setup(vim.tbl_extend("force", defaultOptions, {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          }))
        end,

        --[[ neodev
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
        ['sumneko_lua'] = function()
          lspconfig.sumneko_lua.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                },
                diagnostics = {
                  globals = { 'vim' }
                },
                workspace = {
                  -- shut up about luassert
                  checkThirdParty = false,
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              }
            }
          })
        end,
        ]]

        ["tsserver"] = function()
          -- use jose-elias-alvarez/typescript.nvim instead
          -- This will do lspconfig.tsserver.setup()
          require("typescript").setup(defaultOptions)
        end,
      })
    end,
  },

  -- =========================================================================
  -- Completion
  -- =========================================================================

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "vim-smallcaps",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      --'hrsh7th/cmp-nvim-lua', -- neodev adds to lsp already
      --"roobert/tailwindcss-colorizer-cmp.nvim", -- @TODO formatter not chainable
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
        }, { -- group 2 only if nothing in above had results
          { name = "buffer" },
        }),

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ---@diagnostic disable-next-line: missing-parameter
          ["<C-Space>"] = cmp.mapping.complete(),
        }),

        window = {
          completion = {
            border = "rounded",
            scrollbar = "║",
          },
          documentation = {
            border = "rounded",
            scrollbar = "║",
          },
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local formatted = require("lspkind").cmp_format({
              mode = "symbol_text", -- show only symbol annotations
              menu = {
                buffer = "ʙᴜғ",
                cmdline = "", -- cmp-cmdline used on cmdline
                latex_symbols = "ʟᴛx",
                luasnip = "sɴɪᴘ",
                nvim_lsp = "ʟsᴘ",
                nvim_lua = "ʟᴜᴀ",
                path = "ᴘᴀᴛʜ",
              },
            })(entry, vim_item)
            local strings =
              vim.split(formatted.kind, "%s", { trimempty = true })
            formatted.kind = (strings[1] or "")
            local smallcapsType = vim.fn["smallcaps#convert"](strings[2]) or ""
            formatted.menu = "  "
              .. (formatted.menu or entry.source.name)
              .. " "
              .. smallcapsType
            return formatted
          end,
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } }, -- group 1
          { { name = "cmdline" } } -- group 2, only use if nothing in group 1
        ),
      })

      cmp.setup.filetype({ "markdown", "pandoc", "text", "tex" }, {
        sources = {
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
      })

      vim.keymap.set("n", "<C-Space>", function()
        vim.cmd.startinsert({ bang = true })
        vim.schedule(cmp.complete)
      end, { desc = "In normal mode, `A`ppend and start completion" })
    end,
  },

  -- =========================================================================
  -- Language: Starlark
  -- E.g. Caddy 2 configs, Tilt, Drone, Bazel
  -- No treesitter grammar yet
  -- =========================================================================

  { "cappyzawa/starlark.vim" },
}
