local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  "javascript", -- and jsx
  "tsx",
}

-- table of filetypes
local HIGHLIGHTING_ENABLED = {
  "dotenv",
  "lua",
  "markdown",
  "sh",
  "starlark",
  "tiltfile",
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
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3579#issuecomment-1278662119
        auto_install = true,

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          enable = true,
          disable = function(lang, bufnr)
            -- N.B. sometimes the buffer is special, like Telescope preview!
            -- Or a hover float!

            local ENABLED = false
            local DISABLED = true

            if require("dko.utils.buffer").is_huge({ bufnr = bufnr }) then
              vim.b[bufnr].ts_highlight = {
                enabled = false,
                reason = "hugefile",
              }
              return DISABLED
            end

            if vim.tbl_contains(HIGHLIGHTING_DISABLED, lang) then
              vim.b[bufnr].ts_highlight = {
                enabled = false,
                reason = "blacklisted",
              }
              return DISABLED
            end

            -- Enable for these
            if
              vim.tbl_contains(HIGHLIGHTING_ENABLED, vim.bo[bufnr].filetype)
            then
              vim.b[bufnr].ts_highlight = {
                enabled = true,
                reason = "whitelisted",
              }
              return ENABLED
            end

            vim.b[bufnr].ts_highlight = {
              enabled = false,
              reason = "default",
            }
            return DISABLED
          end,

          -- additional_vim_regex_highlighting = {
          --   "just",
          -- },
        },

        indent = { enable = true },

        matchup = { enable = true },
      })

      -- =====================================================================
      -- Aliases
      -- =====================================================================

      -- Only in nvim 0.9+
      if vim.treesitter.language.register then
        for ft, parser in
          pairs(require("dko.settings").get("treesitter.aliases"))
        do
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
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        context_commentstring = {
          enable = true, -- Comment.nvim wants this
          enable_autocmd = false, -- Comment.nvim wants this
        },
      })
    end,
  },
}
