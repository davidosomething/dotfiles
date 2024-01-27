local tools = require("dko.tools")

tools.register({
  name = "prettier",
  mason_type = "tool",
  require = "npm",
  fts = require("dko.jsts").fts,
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

-- jumping into classnames from jsx/tsx
tools.register({
  name = "cssmodules_ls",
  mason_type = "lsp",
  require = "npm",

  lspconfig = function()
    ---@type lspconfig.Config
    return {
      --- Use :LspStart cssmodules_ls to start this
      autostart = false,

      ---note: local on_attach happens AFTER autocmd LspAttach
      on_attach = function(client)
        -- https://github.com/davidosomething/dotfiles/issues/521
        -- https://github.com/antonk52/cssmodules-language-server#neovim
        -- avoid accepting `definitionProvider` responses from this LSP
        client.server_capabilities.definitionProvider = false
      end,
    }
  end,
})

tools.register({
  name = "eslint",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
})

--"cssls", -- conflicts with tailwindcss
tools.register({
  name = "tailwindcss",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
})

tools.register({
  name = "tsserver",
  mason_type = "lsp",
  require = "npm",
  runner = "mason-lspconfig",
  lspconfig = function()
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

    ---@type lspconfig.Config
    return {
      on_attach = function(client, bufnr)
        require("dko.mappings").bind_tsserver_lsp(client, bufnr)
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
    }
  end,
})
