return {
  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- Some other plugins use treesitter features, so need these even if never
      -- opened a buffer with the corresponding ft
      require("nvim-treesitter")
        .install({
          "html",
          "json",
          "jsx",
          "lua",
          "markdown",
          "tsx",
          "yaml",
        })
        :wait(300000) --- :wait makes it synchronous
      require("dko.treesitter").flush()
    end,
    -- don't use this plugin when headless (lazy.nvim tends to try to install
    -- markdown support async)
    lazy = false,
  },

  -- https://github.com/MaximilianLloyd/tw-values.nvim
  {
    "MaximilianLloyd/tw-values.nvim",
    cmd = "TWValues",
    config = function()
      require("tw-values").setup()
      require("dko.mappings").bind_twvalues()
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = require("dko.mappings").twvalues,
  },

  -- https://github.com/Wansmer/treesj
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 255,
      })
      require("dko.mappings").bind_treesj()
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- https://github.com/aaronik/treewalker.nvim
  {
    "aaronik/treewalker.nvim",
    config = function()
      require("dko.mappings").bind_treewalker()
    end,
  },
}
