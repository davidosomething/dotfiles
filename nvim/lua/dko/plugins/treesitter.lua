return require("dko.utils.lazyspec")(function(ctx)
  ---@type LazySpec
  return {
    -- https://github.com/nvim-treesitter/nvim-treesitter/
    {
      "nvim-treesitter/nvim-treesitter",
      build = function()
        -- The :TSUpdate command is registered in the plugin's plugin/ files,
        -- which lazy.nvim does NOT source before running a build function on a
        -- fresh clone -- so `vim.cmd("TSUpdate")` errors with "Not an editor
        -- command". Call the Lua API directly instead (this is all :TSUpdate
        -- does anyway). On first install nothing is installed yet so this is a
        -- no-op; it only does work on plugin updates.
        if pcall(require, "nvim-treesitter") then
          require("nvim-treesitter").update():wait(300000)
        end
      end,
      commit = "4916d6592ede8c07973490d9322f187e07dfefac",
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
end)
