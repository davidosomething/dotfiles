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
      --'hrsh7th/cmp-nvim-lua', -- neodev adds to lsp already
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      "onsails/lspkind.nvim",
    },

    config = function()
      local snippy = require("snippy")
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
          { name = "nvim_lua" },
          { name = "path" },
        }, { -- group 2 only if nothing in above had results
          { name = "buffer" },
        }),

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),

          -- Snippet mappings
          ["<C-b>"] = cmp.mapping(function()
            if snippy.can_jump(-1) then
              snippy.previous()
            end
            -- DO NOT FALLBACK (i.e. do not insert ^B)
          end, { "i", "s" }),
          ["<C-f>"] = cmp.mapping(function(fallback)
            -- If a snippet is highlighted in PUM, expand it
            if cmp.confirm({ select = false }) then
              return
            end
            -- If in a snippet, jump to next field
            if snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
              return
            end
            fallback()
          end, { "i", "s" }),

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

            local smallcapsType = require("dko.utils.string").smallcaps(
              strings[2]
            ) or ""

            local tailwind_colorized =
              require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

            if tailwind_colorized.kind == "XX" then
              kind_formatted.kind = "X"
              kind_formatted.kind_hl_group = tailwind_colorized.kind_hl_group
              kind_formatted.menu = "  " .. "ᴛᴡ  ᴄᴏʟᴏʀ"
            else
              kind_formatted.menu = "  "
                .. (kind_formatted.menu or entry.source.name)
                .. "." .. smallcapsType
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

      vim.keymap.set("n", "<C-Space>", function()
        vim.cmd.startinsert({ bang = true })
        vim.schedule(cmp.complete)
      end, { desc = "In normal mode, `A`ppend and start completion" })
    end,
  },
}
