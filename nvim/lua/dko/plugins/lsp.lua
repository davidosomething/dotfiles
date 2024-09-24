-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

--local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")
local dkolsp = require("dko.utils.lsp")
local dkotools = require("dko.tools")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- Using this for tsserver specifically, faster results than nvim-lsp
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = has_ui and dkosettings.get("use_coc"),
    init = function()
      vim.g.coc_start_at_startup = false
      vim.g.coc_global_extensions = {
        "coc-eslint",
        "coc-json",
        "coc-tsserver",
      }
    end,
  },

  -- https://github.com/dense-analysis/ale
  -- coc.nvim configured to pipe its diagnostics to ALE
  -- ALE then pipes the diagnostics to vim.diagnostic
  -- We define diagnostic signs in dko.diagnostic
  {
    "dense-analysis/ale",
    init = function()
      vim.g.ale_disable_lsp = 1
      -- only use explicitly enabled linters
      vim.g.ale_linters_explicit = 1

      -- coc
      vim.g.ale_use_neovim_diagnostics_api = 1

      -- diagnostic display
      vim.g.ale_echo_cursor = 0
      vim.g.ale_set_balloons = 0
      vim.g.ale_set_highlights = 0
      vim.g.ale_set_loclist = 0
      vim.g.ale_set_quickfix = 0
      vim.g.ale_set_signs = 1
      vim.g.ale_sign_error = "✖"
      vim.g.ale_sign_warning = ""
      vim.g.ale_sign_info = "⚑"
      vim.g.ale_virtualtext_cursor = "disabled"
    end,
  },

  -- provides modules only
  -- https://github.com/creativenull/efmls-configs-nvim
  { "creativenull/efmls-configs-nvim" },

  -- trying this out
  -- https://github.com/hsaker312/diagnostics-details.nvim/
  {
    "hsaker312/diagnostics-details.nvim",
    cmd = "DiagnosticsDetailsOpenFloat",
    config = function()
      require("diagnostics-details").setup({
        -- Your configuration here
      })
    end,
  },

  -- e.g. for go.mod and swagger yaml
  -- https://github.com/icholy/lsplinks.nvim
  {
    "icholy/lsplinks.nvim",
    cond = has_ui,
    config = function()
      require("lsplinks").setup({
        highlight = true,
        hl_group = "Underlined",
      })
    end,
  },

  -- https://github.com/deathbeam/lspecho.nvim
  -- using fidget.nvim instead
  --{ "deathbeam/lspecho.nvim" },

  -- https://github.com/aznhe21/actions-preview.nvim
  {
    "aznhe21/actions-preview.nvim",
    enabled = dkosettings.get("lsp.code_action") == "actions-preview",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },

  -- This keeps timing out on initial open
  -- https://github.com/rachartier/tiny-code-action.nvim
  -- https://www.reddit.com/r/neovim/comments/1eaxity/rachartiertinycodeactionnvim_a_simple_way_to_run/
  {
    "rachartier/tiny-code-action.nvim",
    enabled = dkosettings.get("lsp.code_action") == "tiny-code-action",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup({ lsp_timeout = 4000 })
    end,
  },

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

  -- {
  --   "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
  --   dev = true,
  --   lazy = true,
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
}
