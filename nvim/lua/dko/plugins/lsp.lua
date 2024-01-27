-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

local mappings = require("dko.mappings")

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
    "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
    dev = true,
    lazy = true,
  },

  -- https://github.com/MaximilianLloyd/tw-values.nvim
  {
    "MaximilianLloyd/tw-values.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = mappings.twvalues,
    config = function()
      require("tw-values").setup()
      mappings.bind_twvalues()
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
      local lspconfig = require("lspconfig")

      ---@param config? table
      local function middleware(config)
        config = config or {}
        return vim.tbl_deep_extend("force", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }, config)
      end

      require("dko.tools").setup_unmanaged_lsps(middleware)

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers =
        require("dko.tools").get_mason_lspconfig_handlers(middleware)
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/init.lua#L62
      handlers[1] = function(server)
        lspconfig[server].setup(middleware())
      end

      require("mason-lspconfig").setup({
        automatic_installation = #vim.api.nvim_list_uis() > 0,
        ensure_installed = require("dko.tools").get_mason_lsps(),
        handlers = handlers,
      })
    end,
  },
}
