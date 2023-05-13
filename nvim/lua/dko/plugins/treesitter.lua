local HAS_GUI = #vim.api.nvim_list_uis() > 0

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

-- ft to treesitter parser
local FT_ALIASES = {
  dotenv = "bash",
  tiltfile = "starlark",
}

local HIGHLIGHTING_MAX_FILESIZE = 300 * 1024 -- 300 KB

return {

  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    cmd = { "TSUpdate" },
    event = { "BufReadPost", "BufNewFile" }, -- this cuts 20ms
    lazy = HAS_GUI,
    config = function()
      require("nvim-treesitter.configs").setup({
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3579#issuecomment-1278662119
        sync_install = HAS_GUI,
        ensure_installed = "all",
        ignore_install = {
          "ada",
          "agda",
          "bass",
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
          "firrtl",
          "foam",
          "fortran",
          "fsh",
          "func",
          "fusion",
          "gleam",
          "hare",
          "heex",
          "hocon",
          "janet_simple",
          "julia",
          "kdl",
          "lalrpop",
          "ledger",
          "m68k",
          "matlab",
          "menhir",
          "meson",
          "mlir",
          "nickel",
          "norg",
          "org",
          "pascal",
          "pioasm",
          "poe_filter",
          "pony",
          "prql",
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
          "tablegen",
          "teal",
          "thrift",
          "tiger",
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
          "zig",
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

        -- 'andymass/vim-matchup',
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("tree-sitter-just").setup({})
    end,
  },
}
