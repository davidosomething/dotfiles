-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

local dkosettings = require("dko.settings")
local dkolsp = require("dko.utils.lsp")
local dkotools = require("dko.tools")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local dev = vim.env.NVIM_DEV ~= nil

return {
  -- ===========================================================================
  -- $/progress
  -- ===========================================================================

  -- https://github.com/deathbeam/lspecho.nvim
  -- using fidget.nvim instead
  --{ "deathbeam/lspecho.nvim" },

  -- ===========================================================================
  -- textDocument/codeAction
  -- ===========================================================================

  -- Decided on fzf-lua instead of these individual plugins
  -- https://github.com/aznhe21/actions-preview.nvim
  -- https://github.com/rachartier/tiny-code-action.nvim keeps timing out on initial open https://www.reddit.com/r/neovim/comments/1eaxity/rachartiertinycodeactionnvim_a_simple_way_to_run/
  -- "nvimdev/lspsaga.nvim" for cursor-based action

  -- ===========================================================================
  -- textDocument/documentLink
  -- ===========================================================================

  -- e.g. for go.mod and swagger yaml
  -- https://github.com/icholy/lsplinks.nvim
  {
    "icholy/lsplinks.nvim",
    cond = has_ui,
    opts = {
      highlight = true,
      hl_group = "Underlined",
    },
  },

  -- ===========================================================================
  -- Multi LSP
  -- ===========================================================================

  -- just provides lua objects to config lspconfig, doesn't call or access other
  -- plugins fns
  -- https://github.com/creativenull/efmls-configs-nvim
  { "creativenull/efmls-configs-nvim" },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- border on :LspInfo window
      require("lspconfig.ui.windows").default_options.border =
        dkosettings.get("border")
    end,
  },

  -- @TODO remove?
  -- https://github.com/pmizio/typescript-tools.nvim
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   cond = has_ui and vim.tbl_contains(dkotools.get_mason_lsps(), "ts_ls"), -- I'm using vtsls now instead
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     local ts_ls_config = require("dko.utils.typescript").ts_ls.config
  --
  --     require("typescript-tools").setup({
  --       on_attach = ts_ls_config.on_attach,
  --       handlers = ts_ls_config.handlers,
  --       settings = {
  --         ts_ls_file_preferences = {
  --           -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3487C1-L3488C1
  --           importModuleSpecifierPreference = "non-relative", -- "project-relative",
  --         },
  --       },
  --     })
  --   end,
  -- },

  -- https://github.com/marilari88/twoslash-queries.nvim
  -- {
  --   "marilari88/twoslash-queries.nvim",
  --   cond = has_ui,
  --   config = function()
  --     require("twoslash-queries").setup({ multi_line = true })
  --   end,
  -- },

  {
    "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
    config = function()
      local cnl = require("cmp_nvim_lsp")
      cnl.setup()
      dkolsp.base_config.capabilities = vim.tbl_deep_extend(
        "force",
        dkolsp.base_config.capabilities,
        cnl.default_capabilities()
      )
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
      "neovim/nvim-lspconfig", -- wait for lspconfig

      -- @TODO move these somewhere else
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
      -- "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
      -- "marilari88/twoslash-queries.nvim", -- ts_ls comment with  ^? comment
    },
    config = function()
      local lspconfig = require("lspconfig")

      dkotools.setup_unmanaged_lsps(dkolsp.middleware)

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers = dkotools.get_mason_lspconfig_handlers(dkolsp.middleware)
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/init.lua#L62
      handlers[1] = function(server)
        lspconfig[server].setup(dkolsp.middleware())
      end

      local lsps = dkotools.get_mason_lsps()
      require("mason-lspconfig").setup({
        automatic_installation = has_ui,
        ensure_installed = lsps,
        handlers = handlers,
      })
    end,
  },

  -- ===========================================================================
  -- coc / TypeScript
  -- ===========================================================================

  {
    "davidosomething/format-ts-errors.nvim",
    cond = has_ui and dkosettings.get("use_coc"),
    dev = dev,
    opts = {
      add_markdown = false,
      start_indent_level = 0,
    },
  },

  {
    "davidosomething/coc-diagnostics-shim.nvim",
    cond = has_ui and dkosettings.get("use_coc"),
    dev = dev,
    dependencies = "davidosomething/format-ts-errors.nvim",
    opts = {
      formatters = {
        coctsserver = {
          ---@diagnostic disable-next-line: unused-local
          function(linter_name, item, formatted)
            ---@type (fun(message: string):string) | nil
            local prettifier = require("format-ts-errors")[item.code]
            if not prettifier then
              vim.schedule(function()
                vim.print(
                  ("format-ts-errors no formatter for [%d] %s"):format(
                    item.code,
                    item.text
                  )
                )
              end)
              return item.text
            end
            local prettified = prettifier(item.text)
            return table.concat({
              prettified,
              "ꜰᴏʀᴍᴀᴛᴛᴇᴅ ᴡɪᴛʜ ꜰᴏʀᴍᴀᴛ-ᴛs-ᴇʀʀᴏʀs.ɴᴠɪᴍ",
            }, "\n")
          end,
        },
      },
    },
  },

  -- Using this for tsserver specifically, faster results than nvim-lsp
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = has_ui and dkosettings.get("use_coc"),
    dependencies = "davidosomething/coc-diagnostics-shim.nvim",
    init = function()
      vim.g.coc_start_at_startup = true
      vim.g.coc_global_extensions = {
        "coc-eslint", -- since it gives code actions unified with tsserver
        "coc-json",
        "coc-tsserver",
        -- "coc-pretty-ts-errors" -- using format-ts-errors instead
      }
    end,
  },
}
