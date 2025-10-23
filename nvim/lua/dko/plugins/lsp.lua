-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

local dkosettings = require("dko.settings")
local wants_cmp = dkosettings.get("completion.engine") == "cmp"

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

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

  -- Options:
  -- fzf-lua
  -- "nvimdev/lspsaga.nvim" for cursor-based action
  -- https://github.com/aznhe21/actions-preview.nvim

  -- https://github.com/rachartier/tiny-code-action.nvim
  -- keeps timing out on initial open https://www.reddit.com/r/neovim/comments/1eaxity/rachartiertinycodeactionnvim_a_simple_way_to_run/
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "folke/snacks.nvim", opts = { terminal = {} } },
    },
    cond = has_ui
      and dkosettings.get("code_action_finder") == "tiny-code-action",
    event = "LspAttach",
    opts = {},
  },

  -- ===========================================================================
  -- textDocument/documentLink
  -- ===========================================================================

  -- e.g. for go.mod and swagger yaml
  -- https://github.com/icholy/lsplinks.nvim
  -- Used in dko.utils.links as first-line gx handler
  {
    "icholy/lsplinks.nvim",
    cond = has_ui,
    event = "LspAttach",
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

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      {
        -- provides some capabilities
        "hrsh7th/cmp-nvim-lsp",
        cond = wants_cmp,
      },
      "neovim/nvim-lspconfig", -- wait for lspconfig

      -- @TODO move these somewhere else
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
    },
    config = function()
      local dkotools = require("dko.tools")

      local lsps = dkotools.get_mason_lsps()
      require("mason-lspconfig").setup({
        automatic_enable = false,
        ensure_installed = lsps,
      })

      -- =====================================================================
      -- Enable lsps
      -- =====================================================================
      if wants_cmp then
        local function resolve_config_and_enable(configs)
          for _, name in pairs(configs) do
            vim.lsp.config(name, require("cmp_nvim_lsp").default_capabilities())
          end
        end
        resolve_config_and_enable()
        resolve_config_and_enable(dkotools.mason_lspconfig_resolvers)
      end
      vim.lsp.enable(dkotools.lspconfig_resolvers)
      vim.lsp.enable(dkotools.mason_lspconfig_resolvers)
    end,
  },
}
