-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

-- Non-lsp tools to install with mason, e.g. to use as a null-ls formatter or
-- diagnostic provider
local extras = {
  "editorconfig-checker",
  "markdownlint",
  "stylua",
}

-- LSPs to install with mason
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local lsps = {
  "ansiblels",
  "bashls",
  "cssls",
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

-- Lazy.nvim specs
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

      -- =====================================================================
      -- Configure formatters
      -- =====================================================================

      local formatters = {
        null_ls.builtins.formatting.beautysh,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.qmlformat,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),
      }
      for i, provider in ipairs(formatters) do
        formatters[i] = provider.with({
          runtime_condition = function(params)
            require("dko.lsp").null_ls_notify_on_format(params)
            local original = provider.runtime_condition
            if original ~= nil then
              return original()
            end
            return true
          end,
        })
      end

      -- =====================================================================
      -- Configure diagnostics
      -- =====================================================================

      local diagnostics = {
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.qmllint,
        null_ls.builtins.diagnostics.zsh,

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
      }
      -- Switch ALL diagnostics to DIAGNOSTICS_ON_SAVE only
      -- or null_ls will keep spamming LSP events
      for i, provider in ipairs(diagnostics) do
        -- @TODO handle existing runtime_condition?
        diagnostics[i] = provider.with({
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        })
      end

      -- =====================================================================
      -- Combine sources
      -- =====================================================================

      local sources = {
        -- provide the typescript.nvim commands as LSP actions
        require("typescript.extensions.null-ls.code-actions"),

        -- add gitsigns.nvim commands
        null_ls.builtins.code_actions.gitsigns.with({
          config = {
            filter_actions = function(title)
              -- only want the "preview hunk" action, I do git stuff in
              -- terminal
              return title:lower():match("preview") ~= nil
            end,
          },
        }),
      }
      require("dko.utils.table").concat(sources, formatters)
      require("dko.utils.table").concat(sources, diagnostics)

      -- =====================================================================
      -- Apply config
      -- =====================================================================

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
    },
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
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

        ["bashls"] = function()
          lspconfig.bashls.setup(vim.tbl_extend("force", defaultOptions, {
            settings = {
              bashIde = {
                shellcheckArguments = "--exclude=SC1090,SC1091",
              },
            },
          }))
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

        ["stylelint_lsp"] = function()
          lspconfig.stylelint_lsp.setup(
            vim.tbl_extend("force", defaultOptions, {
              -- Disable on some filetypes
              -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/stylelint_lsp.lua
              filetypes = {
                "css",
                "less",
                "scss",
                "sugarss",
                -- 'vue',
                "wxss",
                -- 'javascript',
                -- 'javascriptreact',
                -- 'typescript',
                -- 'typescriptreact',
              },
            })
          )
        end,

        ["tsserver"] = function()
          -- use jose-elias-alvarez/typescript.nvim instead
          -- This will do lspconfig.tsserver.setup()
          require("typescript").setup(defaultOptions)
        end,
      })
    end,
  },
}
