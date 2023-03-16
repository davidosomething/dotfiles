return {

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },

  {
    "tsakirist/telescope-lazy.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("lazy")
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "COMMIT_EDITMSG",
          },
          mappings = {
            i = {
              ["<Esc>"] = 'close'
            },
          },
          results_title = false,
        },
        extensions = {
          file_browser = {
            layout_strategy = "vertical",
            layout_config = {
              vertical = {
                height = 0.8,
                width = 0.9,
              },
            },
          },
        },
      })

      require("dko.mappings").bind_telescope()
    end,
  },
}
