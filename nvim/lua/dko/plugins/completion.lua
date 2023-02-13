-- =========================================================================
-- Completion
-- =========================================================================

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      --'hrsh7th/cmp-nvim-lua', -- neodev adds to lsp already
      --"roobert/tailwindcss-colorizer-cmp.nvim", -- @TODO formatter not chainable
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
        }, { -- group 2 only if nothing in above had results
          { name = "buffer" },
        }),

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ---@diagnostic disable-next-line: missing-parameter
          ["<C-Space>"] = cmp.mapping.complete(),
        }),

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
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local formatted = require("lspkind").cmp_format({
              mode = "symbol_text", -- show only symbol annotations
              menu = {
                buffer = "ʙᴜғ",
                cmdline = "", -- cmp-cmdline used on cmdline
                latex_symbols = "ʟᴛx",
                luasnip = "sɴɪᴘ",
                nvim_lsp = "ʟsᴘ",
                nvim_lua = "ʟᴜᴀ",
                path = "ᴘᴀᴛʜ",
              },
            })(entry, vim_item)
            local strings =
              vim.split(formatted.kind, "%s", { trimempty = true })
            formatted.kind = (strings[1] or "")
            local smallcapsType = require('dko.utils.smallcaps').convert(strings[2]) or ""
            formatted.menu = "  "
              .. (formatted.menu or entry.source.name)
              .. " "
              .. smallcapsType
            return formatted
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

      vim.keymap.set("n", "<C-Space>", function()
        vim.cmd.startinsert({ bang = true })
        vim.schedule(cmp.complete)
      end, { desc = "In normal mode, `A`ppend and start completion" })
    end,
  },
}
