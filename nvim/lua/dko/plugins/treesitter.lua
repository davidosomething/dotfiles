local dkomappings = require("dko.mappings")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local FT_TO_LANG_ALIASES = {
  dotenv = "bash",
  javascriptreact = "jsx",
  tiltfile = "starlark",
  typescriptreact = "tsx",
}

-- blacklist if highlighting doesn't look right or is worse than vim regex
local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  --"javascript", -- and jsx
  --"tsx",
}

return {
  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    -- don't use this plugin when headless (lazy.nvim tends to try to install
    -- markdown support async)
    cond = has_ui,
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3579#issuecomment-1278662119
        auto_install = has_ui,
        ensure_installed = has_ui and { "html" } or {},
        sync_install = true,

        -- Built-in modules configured here
        -- see behaviors.lua for treesitter integration with other plugins
        -- or the plugin lazy config itself, like nvim-ts-context-commentstring
        highlight = {
          enable = true,
          disable = function(lang, bufnr)
            return (
              require("dko.utils.buffer").is_huge({ bufnr = bufnr })
              or vim.tbl_contains(HIGHLIGHTING_DISABLED, lang)
            )
          end,

          -- additional_vim_regex_highlighting = {
          --   "just",
          -- },
        },

        indent = { enable = true },

        matchup = { enable = true },
      })

      -- Aliases
      for ft, parser in pairs(FT_TO_LANG_ALIASES) do
        vim.treesitter.language.register(parser, ft)
      end
    end,
  },

  -- https://github.com/MaximilianLloyd/tw-values.nvim
  {
    "MaximilianLloyd/tw-values.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = dkomappings.twvalues,
    config = function()
      require("tw-values").setup()
      dkomappings.bind_twvalues()
    end,
  },
}
