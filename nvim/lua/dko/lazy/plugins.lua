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
  -- utility
  -- =========================================================================

  { "nvim-lua/plenary.nvim" },

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
    dev = vim.fn.getenv('USER') == 'davidosomething',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme meh ]])
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

  -- alternative UI for diagnostics / quickfix / loclist
  {
    "folke/trouble.nvim",
    config = function()
      require('trouble').setup({
        auto_open = false, -- steals focus from mason.nvim :Mason
        auto_close = true,
        auto_preview = false,
        padding = false,
        use_diagnostic_signs = true, -- use built-in signs instead of trouble signs
      })
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    "ghillb/cybu.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require('cybu').setup()
      vim.keymap.set("n", "[b", "<Plug>(CybuPrev)")
      vim.keymap.set("n", "]b", "<Plug>(CybuNext)")
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
      require('colorizer').setup({
        buftypes = {
          '*',
          '!nofile', -- ignore nofile, e.g. :Mason buffer
        }
      })
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
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
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
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'Wansmer/treesj',
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
  {
    'Wansmer/treesj',
    config = function()
      require('treesj').setup()--{ use_default_keymaps = false, max_join_length = 255, })
      vim.keymap.set('n', 'gs', '<Cmd>TSJSplit<CR>', { silent = true })
    end,
  },

  -- =========================================================================
  -- LSP
  -- Scaffold dependencies like LazyVim
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
  -- =========================================================================

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "b0o/schemastore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/typescript.nvim",
      "mason.nvim",
      'weilbith/nvim-code-action-menu',
      "williamboman/mason-lspconfig.nvim",
    }
  },

  {
    'williamboman/mason.nvim',
    cmd = "Mason",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
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
        "remark_ls",
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

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Note that instead of on_attach for each server setup,
      -- diagnostic-lsp.lua has an autocmd defined
      require('mason-lspconfig').setup_handlers({
        function(server)
          require("lspconfig")[server].setup({
            capabilities = capabilities,
          })
        end,

        ['jsonls'] = function()
          require('lspconfig').jsonls.setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,

        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
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
        end,

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
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- This will do lspconfig.tsserver.setup()
      require("typescript").setup({
        capabilities = capabilities,
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
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_window_border = 'single'
      vim.keymap.set('n', '<Leader>ca', '<Cmd>CodeActionMenu<CR>', { noremap = true, silent = true })
    end
  },

  -- =========================================================================
  -- Completion
  -- =========================================================================

  {
    "hrsh7th/nvim-cmp",
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
    end,

    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
    },
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
