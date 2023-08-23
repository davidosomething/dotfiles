-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

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

      local middleware = with_lsp_capabilities

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers = vim.tbl_extend("keep", {
        function(server)
          lspconfig[server].setup(middleware())
        end,
      }, require("dko.tools").get_lspconfig_handlers(middleware))

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = require("dko.tools").get_lsps(),
        handlers = handlers,
      })
    end,
  },
}
