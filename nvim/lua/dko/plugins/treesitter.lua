local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  "javascript", -- and jsx
  "tsx",
}

-- table of filetypes
local HIGHLIGHTING_ENABLED = {
  "dotenv",
  "starlark",
  "tiltfile",
}

local FT_ALIASES = {
  dotenv = "bash",
  tiltfile = "starlark",
}

local HIGHLIGHTING_MAX_FILESIZE = 300 * 1024 -- 300 KB

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
        ignore_install = {
          "ada",
          "agda",
          "beancount",
          "bibtex",
          "bicep",
          "blueprint",
          "chatito",
          "cooklang",
          "cpon",
          "cuda",
          "cue",
          "devicetree",
          "dhall",
          "dot",
          "ebnf",
          "eex",
          "elsa",
          "elvish",
          "embedded_template",
          "foam",
          "fortran",
          "fsh",
          "func",
          "fusion",
          "gleam",
          "heex",
          "hocon",
          "kdl",
          "lalrpop",
          "ledger",
          "m68k",
          "menhir",
          "norg",
          "org",
          "pascal",
          "pioasm",
          "poe_filter",
          "rasi",
          "rego",
          "rnoweb",
          "slint",
          "smali",
          "smithy",
          "sparql",
          "squirrel",
          "supercollider",
          "surface",
          "sxhkdrc",
          "t32",
          "teal",
          "tlaplus",
          "turtle",
          "ungrammar",
          "uxn",
          "uxntal",
          "verilog",
          "vhs",
          "wgsl_bevy",
          "yang",
          "yuck",
        },

        -- ===================================================================
        -- Built-in modules
        -- ===================================================================

        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- Always disable these
            if vim.tbl_contains(HIGHLIGHTING_DISABLED, lang) then
              return true
            end

            -- Disable for large files
            -- See behaviors.lua too
            local ok, stats =
              pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > HIGHLIGHTING_MAX_FILESIZE then
              return true
            end

            -- Enable for these
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if vim.tbl_contains(HIGHLIGHTING_ENABLED, ft) then
              return false
            end

            -- Global setting
            return not require("dko.settings").get(
              "treesitter.highlight_enabled"
            )
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


      -- =====================================================================
      -- Aliases
      -- =====================================================================

      for ft, parser in pairs(FT_ALIASES) do
        require("nvim-treesitter.parsers").filetype_to_parsername[ft] = parser
      end
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
