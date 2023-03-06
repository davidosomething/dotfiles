return {

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "andymass/vim-matchup",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          -- @TODO until I update vim-colors-meh with treesitter @matches
          enable = require("dko.settings").get("treesitter.highlight_enabled"),
          disable = function(lang, buf)
            if
              vim.tbl_contains({
                -- treesitter language, not ft
                -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
                "javascript", -- and jsx
                "tsx",
              }, lang)
            then
              return true
            end

            -- See behaviors.lua too
            -- Disable for large files
            local max_filesize = 300 * 1024 -- 300 KB
            local ok, stats =
              pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },

        indent = { enable = true },

        -- ===================================================================
        -- 3rd party modules
        -- ===================================================================

        -- 'JoosepAlviste/nvim-ts-context-commentstring',
        context_commentstring = { enable = true, enable_autocmd = false },

        -- 'andymass/vim-matchup',
        matchup = { enable = true },
      })
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        context_commentstring = {
          enable = true, -- Comment.nvim wants this
          enable_autocmd = false, -- Comment.nvim wants this
        },
      })
    end,
  },

}
