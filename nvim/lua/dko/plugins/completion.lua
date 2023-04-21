-- =========================================================================
-- Completion
-- =========================================================================

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "dcampos/cmp-snippy", dependencies = { "dcampos/nvim-snippy" } },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      "onsails/lspkind.nvim",
      -- slow start
      --{ "buschco/nvim-cmp-ts-tag-close", opts = { skip_tags = { "img" } } },
    },

    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("snippy").expand_snippet(args.body)
          end,
        },

        sources = cmp.config.sources({
          --{ name = "nvim-cmp-ts-tag-close" },
          { name = "snippy" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, { -- group 2 only if nothing in above had results
          { name = "buffer" },
        }),

        mapping = require("dko.mappings").setup_cmp(),

        window = {
          completion = {
            border = "rounded",
            scrollbar = "║",
          },
          documentation = {
            border = "rounded",
            scrollbar = "║",
          },
        },

        formatting = {
          -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/cmp.lua#L35-L40
          fields = {
            cmp.ItemField.Kind,
            cmp.ItemField.Abbr,
            cmp.ItemField.Menu,
          },
          format = function(entry, vim_item)
            local kind_formatted = require("lspkind").cmp_format({
              mode = "symbol_text", -- show only symbol annotations
              menu = {
                buffer = "ʙᴜꜰ",
                cmdline = "", -- cmp-cmdline used on cmdline
                latex_symbols = "ʟᴛx",
                luasnip = "sɴɪᴘ",
                snippy = "sɴɪᴘ",
                nvim_lsp = "ʟsᴘ",
                nvim_lua = "ʟᴜᴀ",
                path = "ᴘᴀᴛʜ",
              },
            })(entry, vim_item)

            local strings =
              vim.split(kind_formatted.kind, "%s", { trimempty = true })

            kind_formatted.kind = (strings[1] or "")

            local smallcaps_type = require("dko.utils.string").smallcaps(
              strings[2]
            ) or ""

            local tailwind_colorized =
              require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

            if tailwind_colorized.kind == "XX" then
              kind_formatted.kind = "X"
              kind_formatted.kind_hl_group = tailwind_colorized.kind_hl_group
              kind_formatted.menu = ("  %s"):format("ᴛᴡ  ᴄᴏʟᴏʀ")
            else
              kind_formatted.menu = ("  %s.%s"):format(
                kind_formatted.menu or entry.source.name,
                smallcaps_type
              )
            end

            return kind_formatted
          end,
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } }, -- group 1
          { { name = "cmdline" } } -- group 2, only use if nothing in group 1
        ),
      })

      cmp.setup.filetype({ "markdown", "pandoc", "text", "tex" }, {
        sources = {
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
}
