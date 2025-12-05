local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local FT_TO_LANG_ALIASES = {
  dotenv = "bash",
  javascriptreact = "jsx",
  tiltfile = "starlark",
  typescriptreact = "tsx",
}

-- Some other plugins use treesitter features, so need these even if never
-- opened a buffer with the corresponding ft
local ENSURE_INSTALLED = { "html", "json", "lua", "markdown", "yaml" }

return {
  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- don't use this plugin when headless (lazy.nvim tends to try to install
    -- markdown support async)
    cond = has_ui,
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      if has_ui then
        ts.install(ENSURE_INSTALLED):wait(300000) --- :wait makes it synchronous
      end

      -- Aliases
      for ft, parser in pairs(FT_TO_LANG_ALIASES) do
        vim.treesitter.language.register(parser, ft)
      end
    end,
  },

  -- https://github.com/MaximilianLloyd/tw-values.nvim
  {
    "MaximilianLloyd/tw-values.nvim",
    cmd = "TWValues",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = require("dko.mappings").twvalues,
    config = function()
      require("tw-values").setup()
      require("dko.mappings").bind_twvalues()
    end,
  },

  -- https://github.com/Wansmer/treesj
  {
    "Wansmer/treesj",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 255,
      })
      require("dko.mappings").bind_treesj()
    end,
  },

  -- https://github.com/aaronik/treewalker.nvim
  {
    "aaronik/treewalker.nvim",
    config = function()
      require("dko.mappings").bind_treewalker()
    end,
  },
}
