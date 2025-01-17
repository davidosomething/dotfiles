local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = "echasnovski/mini.icons",
    config = function()
      local fzf = require("fzf-lua")
      local actions = require("fzf-lua").actions
      local utils = require("fzf-lua").utils

      local function hl_validate(hl)
        return not utils.is_hl_cleared(hl) and hl or nil
      end

      -- https://github.com/ibhagwan/fzf-lua/blob/main/doc/fzf-lua.txt#L643
      fzf.setup({
        -- too slow, especially for large repo
        git_icons = false,

        winopts = {
          height = 0.90, -- window height
          width = 0.90, -- window width
          preview = {
            default = "bat",
            border = "noborder",
            ---@type 'horizontal'|'vertical'|'flex'
            layout = "vertical",
            vertical = "up:70%", -- up|down:size -- preview goes above the list
          },
          on_create = function()
            -- called once upon creation of the fzf main window
            -- can be used to add custom fzf-lua mappings, e.g:
            --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
            dkomappings.bind_fzf_terminal_mappings()
          end,
        },

        hls = {
          normal = hl_validate("TelescopeNormal"),
          border = hl_validate("TelescopeBorder"),
          title = hl_validate("TelescopePromptTitle"),
          help_normal = hl_validate("TelescopeNormal"),
          help_border = hl_validate("TelescopeBorder"),
          preview_normal = hl_validate("TelescopeNormal"),
          preview_border = hl_validate("TelescopeBorder"),
          preview_title = hl_validate("TelescopePreviewTitle"),
          -- builtin preview only
          cursor = hl_validate("Cursor"),
          cursorline = hl_validate("TelescopeSelection"),
          cursorlinenr = hl_validate("TelescopeSelection"),
          search = hl_validate("IncSearch"),
        },

        fzf_colors = {
          ["fg"] = { "fg", "TelescopeNormal" },
          ["bg"] = { "bg", "TelescopeNormal" },
          ["hl"] = { "fg", "TelescopeMatching" },
          ["fg+"] = { "fg", "TelescopeSelection" },
          ["bg+"] = { "bg", "TelescopeSelection" },
          ["hl+"] = { "fg", "TelescopeMatching" },
          ["info"] = { "fg", "TelescopeMultiSelection" },
          ["border"] = { "fg", "TelescopeBorder" },
          ["gutter"] = "-1",
          ["query"] = { "fg", "TelescopePromptNormal" },
          ["prompt"] = { "fg", "TelescopePromptPrefix" },
          ["pointer"] = { "fg", "TelescopeSelectionCaret" },
          ["marker"] = { "fg", "TelescopeSelectionCaret" },
          ["header"] = { "fg", "TelescopeTitle" },
        },

        fzf_opts = { ["--layout"] = "reverse-list" }, -- input goes below the list

        lsp = {
          jump_to_single_result = true,
          jump_to_single_result_action = actions.file_edit,
        },

        actions = {
          -- Below are the default actions, setting any value in these tables will override
          -- the defaults, to inherit from the defaults change [1] from `false` to `true`
          files = {
            true, -- inherit from defaults, rest are overrides:
            ["enter"] = fzf.actions.file_edit,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },

        previewers = {
          builtin = {
            -- disable tree-sitter syntax highlighting files larger than 100KB
            syntax_limit_b = 1024 * 100, -- 100KB
            treesitter = { enabled = false },
          },
        },
      })
      dkomappings.bind_fzf()

      if dkosettings.get("select") == "fzf" then
        fzf.register_ui_select()
      end
    end,
  },
}
