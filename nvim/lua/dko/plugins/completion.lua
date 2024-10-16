local dkosettings = require("dko.settings")
local smallcaps = require("dko.utils.string").smallcaps

-- =========================================================================
-- Completion
-- =========================================================================

--- More info at https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/entry.lua#L286-L293}
---@class CmpItem
---@field kind string e.g. "Text" or "Method" or "Color" or "File"
---@field kind_hl_group string
---@field abbr string
---@field abbr_hl_group string
---@field menu string the source, shown at end of entry

local SOURCE_MAP = {
  buffer = "ʙᴜꜰ",
  cmdline = "", -- cmp-cmdline used on cmdline
  latex_symbols = "ʟᴛx",
  luasnip = "sɴɪᴘ",
  snippy = "sɴɪᴘ",
  nvim_lsp = "ʟsᴘ",
  nvim_lua = "ʟᴜᴀ",
  path = "ᴘᴀᴛʜ",
}

-- plugin caches
local nhc_ok, nhc

local cmp_dependencies = {
  { "dcampos/cmp-snippy", dependencies = { "dcampos/nvim-snippy" } },

  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/cmp-path",

  { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },

  --- init creates the symbol_map, but also modifies
  --- vim.lsp.protocol.CompletionItemKind :(
  -- "onsails/lspkind.nvim",
}

return {
  {
    -- "hrsh7th/nvim-cmp",
    -- https://github.com/iguanacucumber/magazine.nvim
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    cond = #vim.api.nvim_list_uis() > 0,
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

          ---@param item CmpItem
          format = function(entry, item)
            local raw_kind = item.kind

            -- convert item.kind into a symbol
            local sym, symhl, did_fallback
            ---@diagnostic disable-next-line: undefined-field
            if _G.MiniIcons then
              ---@diagnostic disable-next-line: undefined-field
              sym, symhl, did_fallback = _G.MiniIcons.get("lsp", item.kind)
              -- else
              -- sym = require("lspkind").symbol_map[item.kind]
            end

            -- =================================================================
            -- customize source text at end of entry
            -- =================================================================

            --- printed at end, sᴏᴜʀᴄᴇ of sᴏᴜʀᴄᴇ.ᴛʏᴘᴇ
            local source
            --- printed at end, ᴛʏᴘᴇ of sᴏᴜʀᴄᴇ.ᴛʏᴘᴇ
            local itemtype = ""

            -- [color] thing    ᴄᴏʟᴏʀ
            if nhc_ok == nil then
              nhc_ok, nhc = pcall(require, "nvim-highlight-colors")
            end
            if nhc then
              -- nhc.format() mutates the item (second param) so don't pass
              -- original item
              -- https://github.com/brenoprata10/nvim-highlight-colors/compare/96bd582..f4b6593#diff-b75cdeeaf82700637d57dda632e5d493ae9d90c6ab4ee0735d120e1eb1b0c617R176-R204
              local color_item = nhc.format(entry, { kind = item.kind })
              if color_item.abbr_hl_group then
                item.kind = color_item.abbr
                item.kind_hl_group = color_item.abbr_hl_group
                source = "ᴄᴏʟᴏʀ"
              end
            end

            -- [color] thing    ᴛᴡ
            if not source then
              local tw_colorized =
                require("tailwindcss-colorizer-cmp").formatter(entry, item)
              if tw_colorized.kind == "XX" then
                item.kind = "X"
                item.kind_hl_group = tw_colorized.kind_hl_group
                source = "ᴛᴡ"
              end
            end

            -- [icon] thing    sᴏᴜʀᴄᴇ.ᴛʏᴘᴇ
            if not source then
              item.kind = sym
              item.kind_hl_group = symhl
              source =
                smallcaps(SOURCE_MAP[entry.source.name] or entry.source.name)
              itemtype = (".%s"):format(smallcaps(raw_kind))
            end

            -- =================================================================
            item.menu = ("  %s%s"):format(source, itemtype)
            return item
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
            -- Use <C-Space> to trigger nvim-cmp.
            -- E.g. for tailwindcss completion from nvim-cmp but regular
            -- completion from coc.nvim
            autocomplete = false,
          },
        })
      end
    end,
  },
}
