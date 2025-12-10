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

  -- https://github.com/kosayoda/nvim-lightbulb
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = {
          enabled = true,
          updatetime = 1000,
        },
        code_lenses = true,

        float = { enabled = false },
        sign = { enabled = false },
        --- via NvimLightbulb.get_status_text only
        status_text = { enabled = true },

        ---@type (fun(client_name:string, result:lsp.CodeAction|lsp.Command):boolean)|nil
        ---@diagnostic disable-next-line: unused-local
        filter = function(client, action)
          -- common action.kind prefixes:
          --  quickfix: For fixing diagnostics (errors/warnings).
          --  refactor: For code transformations like extract/inline.
          --  source: For code cleanup, sorting imports, etc..
          --  test: For running or debugging tests.
          --  other: For general or language-specific actions.
          -- pretty much we only want a lightbulb on quickfix
          if
            (action.command and action.command.title == "Disable diagnostics")
            or vim.startswith(action.kind, "refactor")
          then
            return false
          end
          if vim.g.debug_code_actions then
            vim.print(action)
          end
          return true
        end,
      })
    end,
  },

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
    opts = {
      ---@type (fun(action:lsp.CodeAction|lsp.Command,client_name:string, ):string)|nil
      ---@diagnostic disable-next-line: unused-local
      format_title = function(action, client)
        if action.kind then
          return string.format(
            "%s (%s)",
            action.title,
            require("dko.utils.string").smallcaps(action.kind)
          )
        end
        return action.title
      end,
    },
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
  --   cond = has_ui
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
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- provides some capabilities
        "hrsh7th/cmp-nvim-lsp",
        cond = wants_cmp,
      },
      -- @TODO move these somewhere else
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
    },
    config = function()
      local dkotools = require("dko.tools")

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
      end
      vim.lsp.enable(dkotools.lspconfig_resolvers)
    end,
  },
}
