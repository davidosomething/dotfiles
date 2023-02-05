return {
  { "folke/lazy.nvim", version = "*" },

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
    lazy = true,
    cmd = 'Bufferize',
    init = function()
      vim.g.bufferize_command = 'tabnew'
    end,
  },

  -- @TODO nvim 0.9 has :Inspect ?
  {
    'cocopon/colorswatch.vim',
    dependencies = {
      'cocopon/inspecthi.vim',
    },
  },
  {
    'cocopon/inspecthi.vim',
    lazy = true,
    cmd = 'Inspecthi',
    keys = {
      {
        'zs',
        '<Cmd>Inspecthi<CR>',
        desc = 'Show highlight groups under cursor',
        silent = true,
      }
    },
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
      require('stabilize').setup({
        nested = "QuickFixCmdPost,DiagnosticChanged *",
      })
      local stabilizeGroup = vim.api.nvim_create_augroup('dkostabilize', { clear = true })
      -- @TODO fix for trouble
      --[[ vim.api.nvim_create_autocmd('DiagnosticChanged', {
        callback = function()
          -- //vim.cmd('Trouble document_diagnostics')
          -- vim.cmd.doautocmd('User StabilizeRestore')
        end,
        group = stabilizeGroup,
      }) ]]
      vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        pattern = { '[^l]*' },
        command = [[
          copen
          doautocmd User StabilizeRestore
        ]],
        group = stabilizeGroup,
      })
      vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        pattern = { 'l*' },
        command = [[
          lopen
          doautocmd User StabilizeRestore
        ]],
        group = stabilizeGroup,
      })
    end,
  },

  -- =========================================================================
  -- mine
  -- =========================================================================

  -- HR with <Leader>f[CHAR]
  {
    dir = vim.g.vdotdir .. '/mine/vim-hr',
    config = function()
      vim.call('hr#map', '_')
      vim.call('hr#map', '-')
      vim.call('hr#map', '=')
      vim.call('hr#map', '#')
      vim.call('hr#map', '*')
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
    keys = {
      {
        '<Leader>mm',
        '<Cmd>call movemode#toggle()<CR>',
        desc = 'vim-movemode swap between display and line movemodes'
      ,}
    }
  },

  -- =========================================================================
  -- ui
  -- =========================================================================

  -- colorscheme
  {
    "davidosomething/vim-colors-meh",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme meh ]])
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    dependencies = {
      'folke/trouble.nvim',
    },
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      require("indent_blankline").setup({
        -- char = "▏",
        char = "│",
        filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
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

  -- zoom in/out of a window
  -- this plugin accounts for command window and doesn't use sessions
  -- overrides <C-w>o (originally does an :only)
  { 'troydm/zoomwintab.vim' },

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
      require('colorizer').setup()
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
      {
        'junegunn/fzf.vim',
        init = function()
          vim.g.fzf_command_prefix = 'FZF'
          vim.g.fzf_layout = { down = '~40%' }
          vim.g.fzf_buffers_jump = 1
        end,
      },
    },
  },

  -- =========================================================================
  -- File navigation
  -- =========================================================================

  -- Add file manip commands like Remove, Move, Rename, SudoWrite
  -- Do not lazy load, tracks buffers
  { 'tpope/vim-eunuch' },

  -- =========================================================================
  -- Editing
  -- =========================================================================

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      -- 'Wansmer/treesj',
    },
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

  -- <A-hjkl> to move lines in any mode
  {
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup()
    end
  },

  -- gcc / gbc to comment with treesitter integration
  {
    'numToStr/Comment.nvim',
    config = function()
      local ok, mod = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if not ok then
        mod = nil
      end
      local pre_hook = mod and mod.create_pre_hook() or nil
      require('Comment').setup({
        pre_hook = pre_hook,
      })
    end,
  },

  -- @TODO NOT WORKING
  -- {
  --   'Wansmer/treesj',
  --   config = function()
  --     require('treesj').setup()--{ use_default_keymaps = false, max_join_length = 255, })
  --     vim.keymap.set('n', 'gs', '<Cmd>TSJSplit<CR>', { silent = true })
  --   end,
  -- },

  -- =========================================================================
  -- LSP
  -- =========================================================================

  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lsps = {
        "dockerls",
        "eslint",
        "jsonls",
        "sumneko_lua",
        "tsserver",
      }
      if vim.fn.executable('go') == 1 then
        table.insert(lsps, 'gopls')
      end
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
        automatic_installation = true,
      })

      -- Note that instead of on_attach for each server setup,
      -- diagnostic-lsp.lua has an autocmd defined
      require('mason-lspconfig').setup_handlers({
        function (server)
          require("lspconfig")[server].setup({})
        end,
        ['sumneko_lua'] = function ()
          require("lspconfig").sumneko_lua.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          })
        end
      })
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "folke/trouble.nvim",
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'weilbith/nvim-code-action-menu',
    }
  },

  {
    "folke/trouble.nvim",
    config = function()
      require('trouble').setup({
        auto_open = true,
        auto_close = true,
        auto_preview = false,
        padding = false,
        use_diagnostic_signs = true, -- use built-in signs instead of trouble signs
      })
    end,
  },

  -- Redundant since builtin has sign column
  -- Consider later if I want to switch to only float symbol
  -- {
  --   'kosayoda/nvim-lightbulb',
  --   config = function ()
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
    cmd = 'CodeActionMenu',
    config = function ()
      vim.g.code_action_menu_window_border = 'single'
      vim.keymap.set('n', '<Leader>ca', '<Cmd>CodeActionMenu<CR>', { noremap = true, silent = true })
    end
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
