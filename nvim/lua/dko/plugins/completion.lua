local dkosettings = require("dko.settings")

-- =========================================================================
-- Completion
-- =========================================================================

local cmp_dependencies = {
  { "dcampos/cmp-snippy", dependencies = { "dcampos/nvim-snippy" } },

  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/cmp-path",

  { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  "onsails/lspkind.nvim",
}

return {
  {
    "hrsh7th/nvim-cmp",
    cond = #vim.api.nvim_list_uis() > 0,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = cmp_dependencies,
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("snippy").expand_snippet(args.body)
          end,
        },

        sources = cmp.config.sources({
          { name = "snippy" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
        }, { -- group 2 only if nothing in above had results
          { name = "buffer" },
        }),

        window = {
          completion = {
            border = require("dko.settings").get("border"),
            scrollbar = "║",
          },
          documentation = {
            border = require("dko.settings").get("border"),
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
          {
            { name = "path" },
          }, -- group 1
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

      if dkosettings.get("coc.enabled") then
        cmp.setup.filetype(dkosettings.get("coc.fts"), {
          completion = {
            autocomplete = false,
          },
          enabled = false,
          mapping = {},
          sources = {},
        })
      end
    end,
  },
}
