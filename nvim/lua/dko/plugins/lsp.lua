-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

-- Lazy.nvim specs
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        border = "rounded",
        -- defaults to false, but lets just sync it in case I want to change
        -- in my diagnostic.lua
        update_in_insert = vim.diagnostic.config().update_in_insert,
      })

      null_ls.register({ null_ls.builtins.hover.printenv })

      -- =====================================================================
      -- Configure formatters
      -- =====================================================================

      local formatters = {
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--profile black" },
        }),
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.qmlformat,

        -- yamlls formatting is disabled in favor of this
        null_ls.builtins.formatting.yamlfmt,
      }

      -- bind notify when a null_ls formatter has run
      for i, provider in ipairs(formatters) do
        formatters[i] = provider.with({
          runtime_condition = function(params)
            local source = params:get_source()
            vim.notify("format", vim.log.levels.INFO, {
              title = ("LSP > null-ls > %s"):format(source.name),
              render = "compact",
            })

            local original = provider.runtime_condition
            return type(original) == "function" and original() or true
          end,
        })
      end

      null_ls.register(formatters)

      -- =====================================================================
      -- Configure diagnostics
      -- =====================================================================

      local diagnostics = {
        -- dotenv-linter will have to be installed manually
        null_ls.builtins.diagnostics.dotenv_linter.with({
          filetypes = { "dotenv" },
          extra_args = { "--skip", "UnorderedKey" },
        }),
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.qmllint,

        null_ls.builtins.diagnostics.selene.with({
          condition = function()
            local homedir = vim.uv.os_homedir()
            local is_in_homedir = homedir
              and vim.api.nvim_buf_get_name(0):find(homedir)
            if not is_in_homedir then
              return false
            end
            local results = vim.fs.find({ "selene.toml" }, {
              path = vim.api.nvim_buf_get_name(0),
              type = "file",
              upward = true,
            })
            return #results > 0
          end,
          extra_args = function(params)
            local results = vim.fs.find({ "selene.toml" }, {
              path = vim.api.nvim_buf_get_name(0),
              type = "file",
              upward = true,
            })
            if #results == 0 then
              return params
            end
            return { "--config", results[1] }
          end,
        }),

        null_ls.builtins.diagnostics.zsh,
      }
      -- Switch ALL diagnostics to DIAGNOSTICS_ON_SAVE only
      -- or null_ls will keep spamming LSP events
      --[[ for i, provider in ipairs(diagnostics) do
        -- @TODO handle existing runtime_condition?
        diagnostics[i] = provider.with({
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        })
      end ]]

      null_ls.register(diagnostics)
    end,
  },

  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- border on :LspInfo window
      require("lspconfig.ui.windows").default_options.border = "rounded"

      local lspconfig = require("lspconfig")

      -- =====================================================================
      -- The following are LSPs that are not managed by mason-lspconfig. I.e.
      -- not present in
      -- https://github.com/williamboman/mason-lspconfig.nvim/tree/main/lua/mason-lspconfig/server_configurations
      -- =====================================================================

      -- =====================================================================
      -- dart - dart_ls
      -- =====================================================================

      lspconfig.dartls.setup({
        settings = {
          dart = { showTodos = false },
        },
      })

      -- =====================================================================
      -- tiltfile - tilt_ls
      -- =====================================================================

      lspconfig.tilt_ls.setup({})
    end,
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "",
            package_pending = "󱍷",
            package_uninstalled = "",
          },
        },
      })
      -- Auto-install some linters for null-ls
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L157-L163
      -- https://github.com/jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/automatic_installation.lua#LL68C19-L75C7
      local mr = require("mason-registry")
      for _, tool in ipairs(require("dko.tools").get_auto_installable()) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          vim.notify(
            ("Installing %s"):format(p.name),
            vim.log.levels.INFO,
            { title = "mason", render = "compact" }
          )
          p:install():once(
            "closed",
            vim.schedule_wrap(function()
              if p:is_installed() then
                vim.notify(
                  ("Successfully installed %s"):format(p.name),
                  vim.log.levels.INFO,
                  { title = "mason", render = "compact" }
                )
              end
            end)
          )
        end
      end
    end,
  },

  {
    "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
    dev = true,
    lazy = true,
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("tw-values").setup()
      require("dko.mappings").bind_twvalues()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
      "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
      "neovim/nvim-lspconfig", -- wait for lspconfig
      "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
    },
    config = function()
      local function with_lsp_capabilities(opts)
        opts = opts or {}
        return vim.tbl_extend("force", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }, opts)
      end

      local lspconfig = require("lspconfig")

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers = {
        function(server)
          lspconfig[server].setup(with_lsp_capabilities())
        end,
      }

      handlers["cssmodules_ls"] = function()
        lspconfig.cssmodules_ls.setup(with_lsp_capabilities({
          ---note: local on_attach happens AFTER autocmd LspAttach
          ---@param client table
          on_attach = function(client)
            -- https://github.com/davidosomething/dotfiles/issues/521
            -- https://github.com/antonk52/cssmodules-language-server#neovim
            -- avoid accepting `definitionProvider` responses from this LSP
            client.server_capabilities.definitionProvider = false
          end,
        }))
      end

      handlers["docker_compose_language_service"] = function()
        lspconfig.docker_compose_language_service.setup(with_lsp_capabilities({
          on_attach = function(client)
            -- yamlfmt or NOTHING
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        }))
      end

      handlers["efm"] = function()
        lspconfig.efm.setup({
          filetypes = require("dko.lsp.efm").filetypes,
          single_file_support = true,
          init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
          },
          settings = { languages = require("dko.lsp.efm").languages },
        })
      end

      handlers["jsonls"] = function()
        lspconfig.jsonls.setup(with_lsp_capabilities({
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
              validate = { enable = true },
            },
          },
        }))
      end

      handlers["lua_ls"] = function()
        lspconfig.lua_ls.setup(with_lsp_capabilities({
          on_attach = function(client)
            -- stylua or NOTHING
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,

          -- no more neodev https://github.com/neovim/neovim/pull/24592
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if
              not vim.uv.fs_stat(path .. "/.luarc.json")
              and not vim.uv.fs_stat(path .. "/.luarc.jsonc")
            then
              client.config.settings =
                vim.tbl_deep_extend("force", client.config.settings.Lua, {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    library = { vim.env.VIMRUNTIME },
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    --library = vim.api.nvim_get_runtime_file("", true),
                  },
                })
              client.notify(
                "workspace/didChangeConfiguration",
                { settings = client.config.settings }
              )
            end
            return true
          end,

          settings = {
            Lua = {
              format = { enable = false },
              hint = { enable = true },
              workspace = {
                maxPreload = 1000,
                preloadFileSize = 500,
                checkThirdParty = false,
              },
            },
          },
        }))
      end

      handlers["stylelint_lsp"] = function()
        lspconfig.stylelint_lsp.setup(with_lsp_capabilities({
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
        }))
      end

      handlers["tsserver"] = function()
        local inlay_hint_settings = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }

        lspconfig.tsserver.setup(with_lsp_capabilities({
          ---@param _ table client
          ---@param bufnr number
          on_attach = function(_, bufnr)
            require("dko.mappings").bind_tsserver_lsp(bufnr)
          end,

          handlers = {
            [vim.lsp.protocol.Methods.textDocument_publishDiagnostics] = function(
              _,
              result,
              ctx,
              config
            )
              if not result.diagnostics then
                return
              end

              -- ignore some tsserver diagnostics
              local idx = 1
              while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]

                local formatter = require("format-ts-errors")[entry.code]
                entry.message = formatter and formatter(entry.message)
                  or entry.message

                -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                if entry.code == 80001 then
                  -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end

              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
            end,
          },

          settings = {
            typescript = {
              inlayHints = inlay_hint_settings,
            },
            javascript = {
              inlayHints = inlay_hint_settings,
            },
          },
        }))
      end

      handlers["yamlls"] = function()
        lspconfig.yamlls.setup(with_lsp_capabilities({
          settings = {
            yaml = {
              format = { enable = false }, -- prefer yamlfmt
              validate = { enable = false }, -- prefer yamllint
              -- disable built-in fetch schemas, prefer schemastore.nvim
              schemaStore = { enable = false },
              schemas = require("schemastore").yaml.schemas({
                ignore = {
                  "Cheatsheets",
                },
              }),
            },
          },
        }))
      end

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = require("dko.tools").get_auto_installable_lsps(),
        handlers = handlers,
      })
    end,
  },
}
