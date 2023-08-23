local tools = require("dko.tools")

tools.register({
  type = "tool",
  require = "npm",
  name = "prettier",
  runner = "efm",
  efm = function()
    return {
      languages = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      config = require("efmls-configs.formatters.prettier"),
    }
  end,
})

-- jumping into classnames from jsx/tsx
tools.register({
  type = "lsp",
  require = "npm",
  name = "cssmodules_ls",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
    return function()
      require("lspconfig").cssmodules_ls.setup(middleware({
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
  end,
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "eslint",
})

--"cssls", -- conflicts with tailwindcss
tools.register({
  type = "lsp",
  require = "npm",
  name = "tailwindcss",
})

tools.register({
  type = "lsp",
  require = "npm",
  name = "tsserver",
  lspconfig = function(middleware)
    middleware = middleware or function(config)
      return config
    end
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
    return function()
      require("lspconfig").tsserver.setup(middleware({
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
          typescript = { inlayHints = inlay_hint_settings },
          javascript = { inlayHints = inlay_hint_settings },
        },
      }))
    end
  end,
})
