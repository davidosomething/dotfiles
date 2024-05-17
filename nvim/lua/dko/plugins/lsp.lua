-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

--local dkomappings = require("dko.mappings")
local dkolsp = require("dko.lsp")
local dkotools = require("dko.tools")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

-- Lazy.nvim specs
return {
  {
    "creativenull/efmls-configs-nvim",
    lazy = true,
    config = function()
      -- noop
    end,
  },

  {
    "icholy/lsplinks.nvim",
    config = function()
      require("lsplinks").setup({
        highlight = true,
        hl_group = "Underlined",
      })
    end,
  },

  -- https://github.com/deathbeam/lspecho.nvim
  -- { "deathbeam/lspecho.nvim" },

  { "aznhe21/actions-preview.nvim" },

  -- This has a cursor based code_action instead line based, so you get more
  -- specific actions.
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   event = "LspAttach",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter", -- optional
  --     "nvim-tree/nvim-web-devicons", -- optional
  --   },
  --   config = function()
  --     require("lspsaga").setup({
  --       implement = {
  --         enable = false,
  --       },
  --       lightbulb = {
  --         enable = false,
  --       },
  --       symbol_in_winbar = {
  --         enable = false,
  --       },
  --     })
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- border on :LspInfo window
      require("lspconfig.ui.windows").default_options.border = "rounded"
    end,
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local tsserver_config =
        require("dko.tools.javascript-typescript").tsserver.config

      require("typescript-tools").setup({
        on_attach = tsserver_config.on_attach,
        handlers = tsserver_config.handlers,
        settings = {
          tsserver_file_preferences = {
            -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3487C1-L3488C1
            importModuleSpecifierPreference = "non-relative", -- "project-relative",
          },
        },
      })
    end,
  },

  {
    "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
    dev = true,
    lazy = true,
  },

  -- https://github.com/marilari88/twoslash-queries.nvim
  {
    "marilari88/twoslash-queries.nvim",
    cond = has_ui,
    config = function()
      require("twoslash-queries").setup({
        multi_line = true,
      })
    end,
  },

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
      "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
      "marilari88/twoslash-queries.nvim", -- tsserver comment with  ^? comment
    },
    config = function()
      local lspconfig = require("lspconfig")

      ---@param config? table
      local function middleware(config)
        config = config or {}
        return vim.tbl_deep_extend("force", dkolsp.base_config, config)
      end

      dkotools.setup_unmanaged_lsps(middleware)

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers = dkotools.get_mason_lspconfig_handlers(middleware)
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/init.lua#L62
      handlers[1] = function(server)
        lspconfig[server].setup(middleware())
      end

      local lsps = dkotools.get_mason_lsps()
      require("mason-lspconfig").setup({
        automatic_installation = has_ui,
        ensure_installed = lsps,
        handlers = handlers,
      })
    end,
  },
}
