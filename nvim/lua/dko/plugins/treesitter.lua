local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  "javascript", -- and jsx
  "tsx",
}

-- table of filetypes
local HIGHLIGHTING_ENABLED = {
  "just",
  "dotenv",
  "starlark",
  "tiltfile",
}

-- ft to treesitter parser
local FT_ALIASES = {
  dotenv = "bash",
  tiltfile = "starlark",
}

return {

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    -- can't lazy, otherwise vim-matchup will originate errors when you first
    -- open a file before the ts syntax is installed
    lazy = false,
    -- don't use this plugin when headless (lazy.nvim tends to try to install
    -- markdown support async)
    cond = #vim.api.nvim_list_uis() > 0,
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    -- event = { "BufReadPost", "BufNewFile" }, -- this cuts 20ms
    config = function()
      require("nvim-treesitter.configs").setup({
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3579#issuecomment-1278662119
        auto_install = true,

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          enable = true,
          disable = function(lang, bufnr)
            local ENABLED = false
            local DISABLED = true

            if
              not require("dko.settings").get("treesitter.highlight_enabled")
              or vim.tbl_contains(HIGHLIGHTING_DISABLED, lang)
              or require('dko.utils.buffer').is_huge({ bufnr = bufnr })
            then
              return DISABLED
            end

            -- Enable for these
            -- @TODO remove this ignore when signature fixed in neovim
            ---@diagnostic disable-next-line: redundant-parameter
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if vim.tbl_contains(HIGHLIGHTING_ENABLED, ft) then
              return ENABLED
            end

            return DISABLED
          end,
        },

        indent = { enable = true },

        matchup = { enable = true },
      })

      -- =====================================================================
      -- Aliases
      -- =====================================================================

      -- Only in nvim 0.9+
      if vim.treesitter.language.register then
        for ft, parser in pairs(FT_ALIASES) do
          vim.treesitter.language.register(parser, ft)
        end
      end
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
      require("nvim-treesitter.configs").setup({
        context_commentstring = {
          enable = true, -- Comment.nvim wants this
          enable_autocmd = false, -- Comment.nvim wants this
        },
      })
    end,
  },

  {
    "IndianBoy42/tree-sitter-just",
    -- registers filetypes, no lazy
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("tree-sitter-just").setup({})
    end,
  },
}
