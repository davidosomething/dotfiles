local dkosettings = require("dko.settings")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  {
    "saghen/blink.cmp",
    cond = has_ui and dkosettings.get("completion.engine") == "blink",

    -- optional: provides snippets for the snippet source
    dependencies = {
      "nvim-mini/mini.icons",
      -- https://cmp.saghen.dev/configuration/snippets#friendly-snippets
      -- "rafamadriz/friendly-snippets",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "default",
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      cmdline = {
        completion = {
          list = {
            selection = {
              -- https://github.com/Saghen/blink.cmp/blob/5037cfa645a9c4f5d6e2a3f6a44e096df86c8093/lua/blink/cmp/config/modes/cmdline.lua#L11
              preselect = false,
            },
          },
          menu = {
            -- https://cmp.saghen.dev/modes/cmdline.html#show-menu-automatically
            auto_show = true,
          },
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          window = { border = dkosettings.get("pumborder") },
        },
        list = {
          selection = { preselect = false },
        },
        menu = {
          border = dkosettings.get("pumborder"),
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
              { "source_name" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ =
                    require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                text = function(ctx)
                  return require("dko.utils.string").smallcaps(ctx.kind)
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              source_name = {
                text = function(ctx)
                  return require("dko.utils.string").smallcaps(ctx.source_name)
                end,
              },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            -- https://cmp.saghen.dev/configuration/sources.html#show-buffer-completions-with-lsp
            fallbacks = {},
          },
          snippets = { opts = { friendly_snippets = false } },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
