-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

return {
  {
    "linrongbin16/lsp-progress.nvim",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
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
        local clientsString = joinedClients

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

      local notify_on_format = function(params)
        local source = params:get_source()
        vim.notify(
          "Formatting with null-ls/" .. source.name,
          "info",
          { title = "LSP" }
        )
      end

      local formatters = {
        null_ls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.qmlformat,
        null_ls.builtins.formatting.shfmt,
      }
      for i, formatter in ipairs(formatters) do
        -- @TODO handle existing runtime_condition?
        formatters[i] = formatter.with({
          runtime_condition = function(params)
            notify_on_format(params)
            return true
          end,
        })
      end

      local sources = vim.tbl_extend("force", {
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
      }, formatters)

      null_ls.setup({
        border = "rounded",
        sources = sources,
        -- defaults to false, but lets just sync it in case I want to change
        -- in my diagnostic-lsp.lua
        update_in_insert = vim.diagnostic.config().update_in_insert,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
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
        "prettier",
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
        "dockerls",
        "eslint",
        "html",
        "jsonls",
        "stylelint_lsp",
        "lua_ls",
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
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
      ['lua_ls'] = function()
        lspconfig.lua_ls.setup({
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
}
