-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

-- Debugging flags
local ENABLED = true
local NULL_LS_ENABLED = true
local TSSERVER_ENABLED = true
local CSSMODULES_ENABLED = true
local TRACE = false
if TRACE then
  vim.lsp.set_log_level("trace")
  if vim.fn.has("nvim-0.5.1") == 1 then
    ---@diagnostic disable-next-line: param-type-mismatch
    require("vim.lsp.log").set_format_func(vim.inspect)
  end
end

-- Tools to auto-install with mason
-- Must then be configured, e.g. as null-ls formatter or diagnostic provider
local extras = {
  "markdownlint",
  "prettier",
  "selene",
  "shellcheck", -- used by null_ls AND bashls
  "shfmt", -- null_ls formatting
  "stylua",
}
local when_executable = {
  black = "python",
  isort = "python",
  vint = "python",
}
for lsp, bin in pairs(when_executable) do
  if vim.fn.executable(bin) == 1 then
    table.insert(extras, lsp)
  end
end

-- LSPs to install with mason via mason-lspconfig
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local lsps = {
  "ansiblels",
  --"bashls", -- prefer null_ls shellcheck, has code_actions and code inline
  "cssls",
  "cssmodules_ls", -- jumping into classnames from jsx/tsx
  "docker_compose_language_service",
  "dockerls",
  "eslint",
  "html",
  "jdtls",
  "jsonls",
  "stylelint_lsp",
  "lua_ls",

  -- temporary -- using jedi instead of futzing around with venvs ?
  -- https://github.com/neovim/nvim-lspconfig/issues/500
  -- do :PylspInstall <tab> after to install plugins!!
  --"pylsp",

  "tailwindcss",
  "tsserver",
  "vimls",
  "yamlls",
}
when_executable = {
  gopls = "go",
  jedi_language_server = "python",
}
for lsp, bin in pairs(when_executable) do
  if vim.fn.executable(bin) == 1 then
    table.insert(lsps, lsp)
  end
end

-- Lazy.nvim specs
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = NULL_LS_ENABLED,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    config = function()
      local null_ls = require("null-ls")

      -- =====================================================================
      -- Configure formatters
      -- =====================================================================

      local formatters = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.qmlformat,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
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
        -- dotenv-linter will have to be installed manually
        null_ls.builtins.diagnostics.dotenv_linter.with({
          filetypes = { "dotenv" },
          extra_args = { "--skip", "UnorderedKey" },
        }),
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.qmllint,
        null_ls.builtins.diagnostics.shellcheck.with({
          diagnostics_format = "SC#{c}: #{m}",
        }),
        null_ls.builtins.diagnostics.vint,
        null_ls.builtins.diagnostics.zsh,

        null_ls.builtins.diagnostics.selene.with({
          condition = function()
            local homedir = vim.loop.os_homedir()
            local is_in_homedir = homedir
              and vim.api.nvim_buf_get_name(0):find(homedir)
            if not is_in_homedir then
              return false
            end
            local results = vim.fs.find({ "selene.toml" }, {
              path = vim.api.nvim_buf_get_name(0),
              upward = true,
              stop = vim.loop.os_homedir(),
            })
            return #results > 0
          end,
          extra_args = function(params)
            local results = vim.fs.find({ "selene.toml" }, {
              path = vim.api.nvim_buf_get_name(0),
              stop = vim.loop.os_homedir(),
              upward = true,
            })
            if #results == 0 then
              return params
            end
            return { "--config", results[1] }
          end,
        }),
      }
      -- Switch ALL diagnostics to DIAGNOSTICS_ON_SAVE only
      -- or null_ls will keep spamming LSP events
      --[[ for i, provider in ipairs(diagnostics) do
        -- @TODO handle existing runtime_condition?
        diagnostics[i] = provider.with({
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        })
      end ]]

      -- =====================================================================
      -- Combine sources
      -- =====================================================================

      local sources = {
        null_ls.builtins.hover.printenv,

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

        -- bashls does not provide these quick ignore actions
        null_ls.builtins.code_actions.shellcheck,
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
        -- in my diagnostic.lua
        update_in_insert = vim.diagnostic.config().update_in_insert,
      })
    end,
  },

  {
    "folke/neodev.nvim",
    lazy = true,
    config = function()
      require("neodev").setup({
        override = function(root_dir, library)
          if root_dir:find("nvim") then
            library.enabled = true
          end
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    enabled = ENABLED,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neodev.nvim",
    },
    config = function()
      require("lspconfig").tilt_ls.setup({})
      -- border on :LspInfo window
      require("lspconfig.ui.windows").default_options.border = "rounded"
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
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      -- Auto-install some linters for null-ls
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L157-L163
      -- https://github.com/jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/automatic_installation.lua#LL68C19-L75C7
      local mr = require("mason-registry")
      for _, tool in ipairs(extras) do
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
    "williamboman/mason-lspconfig.nvim",
    enabled = ENABLED,
    dependencies = {
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
      "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
      "neovim/nvim-lspconfig", -- wait for lspconfig, which waits for neodev
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

        ["cssmodules_ls"] = function()
          if not CSSMODULES_ENABLED then
            return
          end
          lspconfig.cssmodules_ls.setup(with_lsp_capabilities({
            ---@param client table
            on_attach = function(client)
              -- https://github.com/davidosomething/dotfiles/issues/521
              -- https://github.com/antonk52/cssmodules-language-server#neovim
              -- avoid accepting `definitionProvider` responses from this LSP
              client.server_capabilities.definitionProvider = false
            end,
          }))
        end,

        ["jsonls"] = function()
          lspconfig.jsonls.setup(with_lsp_capabilities({
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          }))
        end,

        ["lua_ls"] = function()
          lspconfig.lua_ls.setup(with_lsp_capabilities({
            ---@param client table
            on_attach = function(client)
              -- stylua or NOTHING
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
            settings = {
              Lua = {
                format = {
                  enable = false,
                },
                workspace = {
                  maxPreload = 1000,
                  preloadFileSize = 500,
                  checkThirdParty = false,
                },
              },
            },
          }))
        end,

        ["stylelint_lsp"] = function()
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
        end,

        ["tsserver"] = function()
          if not TSSERVER_ENABLED then
            return
          end
          lspconfig.tsserver.setup(with_lsp_capabilities({
            ---@param _ table client
            ---@param bufnr number
            on_attach = function(_, bufnr)
              require("dko.mappings").bind_tsserver_lsp(bufnr)
            end,

            handlers = {
              ["textDocument/publishDiagnostics"] = function(
                _,
                result,
                ctx,
                config
              )
                if result.diagnostics == nil then
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

                vim.lsp.diagnostic.on_publish_diagnostics(
                  _,
                  result,
                  ctx,
                  config
                )
              end,
            },
          }))
        end,

        ["yamlls"] = function()
          lspconfig.yamlls.setup(with_lsp_capabilities({
            settings = {
              yaml = {
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          }))
        end,
      }

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = lsps,
        handlers = handlers,
      })
    end,
  },
}
