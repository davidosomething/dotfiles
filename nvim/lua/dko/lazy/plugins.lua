local function textobjMap(obj, char)
  char = char or obj:sub(1, 1)
  vim.keymap.set('o', 'a' .. char, '<Plug>(textobj-' .. obj .. '-a)', {
    desc = 'Operator - around ' .. obj,
  })
  vim.keymap.set('x', 'a' .. char, '<Plug>(textobj-' .. obj .. '-a)', {
    desc = 'Visual - around ' .. obj,
  })
  vim.keymap.set('o', 'i' .. char, '<Plug>(textobj-' .. obj .. '-i)', {
    desc = 'Operator - inside ' .. obj,
  })
  vim.keymap.set('x', 'i' .. char, '<Plug>(textobj-' .. obj .. '-i)', {
    desc = 'Visual - inside ' .. obj,
  })
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
    'AndrewRadev/bufferize.vim',
    cmd = 'Bufferize',
    init = function()
      vim.g.bufferize_command = 'tabnew'
    end,
    config = function()
      vim.api.nvim_create_user_command('Bmessages', 'Bufferize messages', {
        desc = "Open messages in new buffer",
      })
    end,
  }, 

  {
    'nvim-treesitter/playground',
    config = function()
      vim.keymap.set('n', 'ss', '<Cmd>TSHighlightCapturesUnderCursor<CR>', {
        desc = 'Show treesitter highlight group under cursor',
      })
      vim.keymap.set('n', 'sn', '<Cmd>TSNodeUnderCursor<CR>', {
        desc = 'Show treesitter node under cursor',
      })
    end,
  },

  -- =========================================================================
  -- fixes
  -- =========================================================================

  -- Fix CursorHold
  -- https://github.com/neovim/neovim/issues/12587
  {
    'antoinemadec/FixCursorHold.nvim',
    enabled = vim.fn.has('nvim-0.8') == 0,
  },

  -- Disable cursorline when moving, for various perf reasons
  { "delphinus/auto-cursorline.nvim", },

  -- =========================================================================
  -- polyfills
  -- =========================================================================

  -- apply editorconfig settings to buffer
  -- @TODO follow https://github.com/neovim/neovim/issues/21648
  {
    'gpanders/editorconfig.nvim',
    enabled = vim.fn.has('nvim-0.9') == 0,
  }, 

  -- prevent new windows from shifting cursor position
  {
    'luukvbaal/stabilize.nvim',
    enabled = vim.fn.exists('+splitkeep') == 0,
    config = function()
      require('stabilize').setup()
    end,
  },

  -- =========================================================================
  -- mine
  -- =========================================================================

  -- HR with <Leader>f[CHAR]
  {
    dir = vim.g.vdotdir .. '/mine/vim-hr',
    config = function()
      local map = vim.fn['hr#map']
      map('_')
      map('-')
      map( '=')
      map( '#')
      map( '*')
    end
  },

  -- <Leader>C <Plug>(dkosmallcaps)
  {
    dir = vim.g.vdotdir .. '/mine/vim-smallcaps',
    keys = {
      {
        '<Leader>C',
        '<Plug>(dkosmallcaps)',
        mode = 'v',
        desc = 'Apply vim-smallcaps to visual selection',
      },
    },
  },

  -- Toggle movement mode line-wise/display-wise
  {
    dir = vim.g.vdotdir .. '/mine/vim-movemode',
    lazy = false, -- I use the autoload fns
    config = function()
      vim.keymap.set('n', '<Leader>mm', '<Cmd>call movemode#toggle()<CR>', {
        desc = 'Toggle move mode',
      })
    end
  },

  -- =========================================================================
  -- ui
  -- =========================================================================

  -- colorscheme
  {
    "davidosomething/vim-colors-meh",
    dev = vim.fn.getenv('USER') == 'davidosomething',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme meh ]])
    end,
  },

  {
    'rcarriga/nvim-notify',
    lazy = false,
    priority = 1000,
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
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

  -- shrink quickfix to fit
  {
    'blueyed/vim-qf_resize',
    init = function()
      vim.g.qf_resize_min_height = 4
    end,
  },

  -- pretty format quickfix and loclist
  {
    'https://gitlab.com/yorickpeterse/nvim-pqf.git',
    config = function()
      local SIGNS = require('dko.diagnostic-lsp').SIGNS
      require('pqf').setup({
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

  -- super buggy
  --[[ {
    'ten3roberts/qf.nvim',
    config = function()
      require('qf').setup({
        -- Location list configuration
        l = {
          auto_close = true, -- Automatically close location/quickfix list if empty
          auto_follow = false, -- Follow current entry, possible values: prev,next,nearest, or false to disable
          auto_follow_limit = 8, -- Do not follow if entry is further away than x lines
          follow_slow = true, -- Only follow on CursorHold
          auto_open = true, -- Automatically open list on QuickFixCmdPost
          auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
          max_height = 8, -- Maximum height of location/quickfix list
          min_height = 5, -- Minimum height of location/quickfix list
          wide = false, -- Open list at the very bottom of the screen, stretching the whole width.
          number = false, -- Show line numbers in list
          relativenumber = false, -- Show relative line numbers in list
          unfocus_close = false, -- Close list when window loses focus
          focus_open = false, -- Auto open list on window focus if it contains items
        },
        -- Quickfix list configuration
        c = {
          auto_close = true, -- Automatically close location/quickfix list if empty
          auto_follow = false, -- Follow current entry, possible values: prev,next,nearest, or false to disable
          auto_follow_limit = 8, -- Do not follow if entry is further away than x lines
          follow_slow = true, -- Only follow on CursorHold
          auto_open = true, -- Automatically open list on QuickFixCmdPost
          auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
          max_height = 8, -- Maximum height of location/quickfix list
          min_height = 5, -- Minimum height of location/quickfix list
          wide = false, -- Open list at the very bottom of the screen, stretching the whole width.
          number = false, -- Show line numbers in list
          relativenumber = false, -- Show relative line numbers in list
          unfocus_close = false, -- Close list when window loses focus
          focus_open = false, -- Auto open list on window focus if it contains items
        },
        close_other = false, -- Close location list when quickfix list opens
        pretty = true, -- "Pretty print quickfix lists"
      })
    end,
  }, ]]

  -- alternative UI for diagnostics / quickfix / loclist
  -- I prefer using builtin vim.diagnostic.setloclist
  --[[ {
    "folke/trouble.nvim",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('trouble').setup({
        auto_open = false, -- steals focus from mason.nvim :Mason
        auto_close = true,
        auto_preview = false,
        padding = false,
        use_diagnostic_signs = true, -- use built-in signs instead of trouble signs
      })
    end,
  }, ]]

  {
    "ghillb/cybu.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim"
    },
    keys = {
      {
        "[b",
        "<Plug>(CybuPrev)",
        desc = 'Previous buffer with cybu popup',
      },
      {
        "]b",
        "<Plug>(CybuNext)",
        desc = 'Next buffer with cybu popup',
      },
    },
    config = function()
      require('cybu').setup({
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
    'troydm/zoomwintab.vim',
    keys = {
      '<C-w>o',
      '<C-w><C-o>',
    },
    cmd = {
      'ZoomWinTabIn',
      'ZoomWinTabOut',
      'ZoomWinTabToggle',
    },
  },

  -- resize window to selection, or split new window with selection size
  {
    'wellle/visual-split.vim',
    cmd = {
      'VSResize',
      'VSSplit',
      'VSSplitAbove',
      'VSSplitBelow'
    },
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        buftypes = {
          '*',
          '!nofile', -- ignore nofile, e.g. :Mason buffer
        }
      })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gs = require('gitsigns')
      gs.setup({
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Prev hunk' })

          -- Actions
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {
            desc = 'Reset hunk',
          })
          map('n', 'gb',
            function() gs.blame_line({ full = true }) end,
            { desc = 'Show blames' }
          )

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {
            desc = 'Select hunk',
          })
        end
      })
    end,
  },

  -- gitsigns.nvim is providing blame
  --[[ {
    'rhysd/git-messenger.vim',
    keys = {
      {
        'gb',
        '<Plug>(git-messenger)',
        desc = 'Open git-messenger popup'
      },
    },
    cmd = 'GitMessenger',
    init = function()
      vim.g.git_messenger_include_diff = 'current'
      vim.g.git_messenger_no_default_mappings = true
      vim.g.git_messenger_floating_win_opts = { border = 'rounded' } --  :h api-win_config
      vim.g.git_messenger_max_popup_height = 16
      vim.g.git_messenger_popup_content_margins = true
    end,
  }, ]]

  {
    'numtostr/FTerm.nvim',
    keys = {
      {
        '<A-i>',
        function()
          require('FTerm').toggle()
        end,
        desc = 'Toggle FTerm',
      },
    },
    config = function()
      require('FTerm').setup({
        border = 'rounded',
      })
      vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
  },

  -- =========================================================================
  -- ui: fzf
  -- =========================================================================

  -- Use the repo instead of the version in brew since it includes the help
  -- docs for fzf#run()
  {
    'junegunn/fzf',
    enabled = vim.fn.exists('&autochdir') == 1,
    dependencies = {
      'junegunn/fzf.vim',
    },
  },
  {
    'junegunn/fzf.vim',
    init = function()
      vim.g.fzf_command_prefix = 'FZF'
      vim.g.fzf_layout = { down = '~40%' }
      vim.g.fzf_buffers_jump = 1
    end,
  },

  -- =========================================================================
  -- Editing
  -- =========================================================================

  -- Add external modifications as new state in undofile
  --[[ {
    'kevinhwang91/nvim-fundo',
    event = 'BufReadPost',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    build = function() require('fundo').install() end,
    config = function()
      require('fundo').setup()
    end
  },]] 

  -- Add file manip commands like Remove, Move, Rename, SudoWrite
  -- Do not lazy load, tracks buffers
  { 'tpope/vim-eunuch' },

  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({})
    end,
  },

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    dependencies = {
      'andymass/vim-matchup',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/playground',
      'Wansmer/treesj',
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 'JoosepAlviste/nvim-ts-context-commentstring',
        context_commentstring = { enable = true, enable_autocmd = false },
        -- 'andymass/vim-matchup',
        matchup = { enable = true },
        -- 'nvim-treesitter/playground'
        playground = { enable = true },

        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "bash",
          "help",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
      })
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('nvim-treesitter.configs').setup({
        context_commentstring = {
          enable = true, -- Comment.nvim wants this
          enable_autocmd = false, -- Comment.nvim wants this
        }
      })
    end,
  },

  -- highlight matching html/xml tag
  {
    'andymass/vim-matchup',
    init = function()
      vim.g.matchup_delim_noskips = 2
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_status_offscreen = 0
    end,
  },

  -- <A-hjkl> to move lines in any mode
  {
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup()
    end,
  },

  -- gcc / <Leader>gbc to comment with treesitter integration
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap (default gc)
          line = 'gc',
          ---Block-comment keymap (gb is my blame command)
          block = '<Leader>gb',
        },
        toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = '<Leader>gbc',
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end,
  },

  {
    'Wansmer/treesj',
    keys = {
      {
        'gs',
        '<Cmd>TSJToggle<CR>',
        desc = 'Toggle treesitter split / join',
        silent = true,
      },
    },
    config = function()
      require('treesj').setup({
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
    'machakann/vim-sandwich',
  },

  {
    'kana/vim-textobj-indent',
    dependencies = { 'kana/vim-textobj-user' },
    config = function()
      textobjMap('indent')
      vim.keymap.set('n', '<Leader>s', 'vii:!sort<CR>', {
        desc = "Auto select indent and sort",
        remap = true, -- since ii is a mapping too
      })
    end,
  },
  {
    'gilligan/textobj-lastpaste',
    dependencies = { 'kana/vim-textobj-user' },
    config = function() textobjMap('paste', 'P') end,
  },
  {
    'mattn/vim-textobj-url',
    dependencies = { 'kana/vim-textobj-user' },
    config = function() textobjMap('url') end,
  },

  -- =========================================================================
  -- LSP
  -- Scaffold dependencies like LazyVim
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
  -- =========================================================================

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        border = 'rounded',
        sources = {
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.editorconfig_checker,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.qmllint,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.qmlformat,
          null_ls.builtins.formatting.markdownlint,
          null_ls.builtins.formatting.shfmt,
        },
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    dependencies = {
      { 'folke/neodev.nvim', config = true },
      "jose-elias-alvarez/typescript.nvim",
      'nvim-lua/lsp-status.nvim',
      'weilbith/nvim-code-action-menu',
      "williamboman/mason.nvim",
    }
  },

  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      local lsp_status = require('lsp-status')

      local SIGNS = require('dko.diagnostic-lsp').SIGNS
      lsp_status.config({
        current_function = false,
        indicator_errors = SIGNS.Error,
        indicator_warnings = SIGNS.Warn,
        indicator_info = SIGNS.Info,
        indicator_hint = SIGNS.Hint,
        indicator_ok = '✓',
        status_symbol = '',
      })

      lsp_status.register_progress()
    end,
  },

  {
    'williamboman/mason.nvim',
    cmd = "Mason",
    opts = {
      ui = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local extras = {
        'editorconfig-checker',
        'markdownlint',
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
      'neovim/nvim-lspconfig', -- wait for lspconfig, which waits for neodev
      'nvim-lua/lsp-status.nvim',
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
        "sumneko_lua",
        "tailwindcss",
        "tsserver",
        "vimls",
        "yamlls",
      }
      if vim.fn.executable('go') == 1 then
        table.insert(lsps, 'gopls')
      end
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
        automatic_installation = true,
      })

      local defaultOptions = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = require('lsp-status').on_attach,
      }

      -- Note that instead of on_attach for each server setup,
      -- diagnostic-lsp.lua has an autocmd defined
      require('mason-lspconfig').setup_handlers({
        function(server)
          require("lspconfig")[server].setup(defaultOptions)
        end,

        ['jsonls'] = function()
          require('lspconfig').jsonls.setup(vim.tbl_extend('force', defaultOptions, {
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          }))
        end,

        -- neodev
        --[[ -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
        ['sumneko_lua'] = function()
          require("lspconfig").sumneko_lua.setup({
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
        end, ]]

        ['tsserver'] = function()
          -- noop
          -- use jose-elias-alvarez/typescript.nvim instead
        end
      })
    end,
  },

  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      -- This will do lspconfig.tsserver.setup()
      require("typescript").setup({
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = require('lsp-status').on_attach,
      })
    end,
  },

  -- Redundant since builtin has sign column
  -- Consider later if I want to switch to only float symbol
  -- {
  --   'kosayoda/nvim-lightbulb',
  --   config = function()
  --     require('nvim-lightbulb').setup({
  --       autocmd = { enabled = true },
  --       sign = { enabled = false },
  --       float = { enabled = true },
  --     })
  --   end,
  -- },

  -- nicer looking than built-in codeaction menu
  {
    'weilbith/nvim-code-action-menu',
    keys = {
      {
        '<Leader>ca',
        '<Cmd>CodeActionMenu<CR>',
        desc = 'Open Code Action menu',
        noremap = true,
        silent = true
      },
    },
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_window_border = 'single'
    end
  },

  -- Don't need it
  --[[ {
    "glepnir/lspsaga.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    event = "BufRead",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          sign = false,
          virtual_text = false,
        }
      })
    end,
  }, ]]

  -- too disruptive
  --[[ {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  }, ]]

  -- =========================================================================
  -- Completion
  -- =========================================================================

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      --"roobert/tailwindcss-colorizer-cmp.nvim", -- @TODO formatter not chainable
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua' },
        }),

        mapping = {
          ['<C-n>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,

          ['<C-p>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end
        },

        window = {
          completion = {
            border = 'rounded',
            scrollbar = '║',
          },
          documentation = {
            border = 'rounded',
            scrollbar = '║',
          },
        }
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      cmp.setup({
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
          })
        }
      })
    end,
  },

  -- =========================================================================
  -- Language: Git
  -- =========================================================================

  -- show diff when editing a COMMIT_EDITMSG
  {
    'rhysd/committia.vim',
    lazy = false, -- just in case
    init = function()
      vim.g.committia_open_only_vim_starting = 0
      vim.g.committia_use_singlecolumn = 'always'
    end,
  },

  -- =========================================================================
  -- Language: Lua
  -- =========================================================================

  -- @TODO temp
  -- Fix gf on lua files when doing nvim config
  { 'sam4llis/nvim-lua-gf' },

}
